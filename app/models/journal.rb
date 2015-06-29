class Journal < ActiveRecord::Base
  belongs_to :author
  belongs_to :category

  validates_presence_of :remote_id, :posted_at, :title, :body

  serialize :data, JSON

  default_scope -> { order posted_at: :desc }

  def self.sync! teamwork
    teamwork.all_journals.each do |data|
      remote_id = data.fetch('id').to_i

      where(remote_id: remote_id).first_or_create! do |j|
        first_name = data.fetch('author-first-name')
        last_name  = data.fetch('author-last-name')

        j.posted_at = DateTime.parse data.fetch 'posted-on'
        j.title     = data.fetch 'title'
        j.body      = data.fetch 'body'
        j.read      = data.fetch('isRead') == '1'
        j.data      = data

        j.author      = Author.lookup first_name, last_name
        j.author_name = if j.author.present?
          j.author.name
        else
          "#{first_name} #{last_name}".strip unless j.author
        end

        j.category = Category.lookup data.fetch 'category-name'
        j.remote_category_id = data.fetch('category-id')
      end
    end
  end

  def self.guess_weeks!
    find_each { |j| j.update_attributes week: j.guessed_week }
  end

  def self.push_all_categories! teamwork
    missing = Journal.find_each.select { |j| j.remote_category_id.nil? && j.category.present? }
    missing.each_slice 50 do |slice|
      slice.each do |journal|
        journal.push_category_to_teamwork! teamwork
      end
      Rails.logger.info "Pausing for 15 seconds for rate limiting ..."
      sleep 15
    end
  end

  def remote_url
    "#{Teamwork::TEAMWORK_URL}/messages/#{remote_id}"
  end

  def author_name
    super || author.try(:name)
  end

  def category
    super || category_from_author || category_from_title
  end

  def category_from_author
    author.default_category.tap do |c|
      c.guessed = true
      c.from = :author
    end if author.try(:default_category)
  end

  def category_from_title
    guess = guessed_category_name_from_title
    return unless guess
    Category.lookup(guess).tap do |c|
      c.guessed = true
      c.from = :title
    end
  end

  def guessed_category_name_from_title
    if title =~ /\.rb/i || title =~ /ruby/i || title =~ /RoR/
      "Ruby / Rails"
    elsif title =~ /\.js/i || title =~ /javascript/i || title =~ /FEE/ || title =~ /JS/
      "Front End"
    elsif title =~ /\.py/i || title =~ /python/i
      "Python"
    elsif title =~ /CD/i
      "Campus Directors"
    elsif title =~ /web design/i
      "Web Design"
    elsif title =~ /iOS/
      "iOS"
    end
  end

  def guessed_week
    if m = (/w(eek|k)?\.?\s*(\d+)/i).match(title)
      m.to_a.last
    elsif title =~ /#(\d+)/
      $1
    end
  end

  def push_category_to_teamwork! teamwork
    if remote_category_id
      Rails.logger.info "Refusing to overwrite remote category id for #{remote_id}"
      return
    end
    return unless category
    teamwork.update_journal_category! remote_id, data, category.remote_id
    update_attributes(
      category_id:        category.id,
      remote_category_id: category.remote_id
    )
  end
end
