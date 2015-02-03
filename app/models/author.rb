class Author < ActiveRecord::Base
  belongs_to :default_category, class_name: "Category"
  has_many :journals

  validates_presence_of :remote_id, :first_name, :last_name, :data

  # remote_ids seem to be wonky for a few people, so we'll look up by name
  validates_uniqueness_of :first_name, scope: :last_name

  serialize :data, JSON

  default_scope -> { order last_name: :asc }

  def self.sync! teamwork
    teamwork.authors.each do |remote|
      where(remote_id: remote.fetch('id')).first_or_create! do |a|
        a.first_name = remote.fetch 'first-name'
        a.last_name  = remote.fetch 'last-name'
        a.email      = remote.fetch 'email-address'
        a.data       = remote
      end
    end
  end

  def self.lookup first_name, last_name
    # FIXME: this should probably fetch from a cache
    # FIXME: why don't the remote ids line up?!
    # May return nil, e.g. if the journal was written by an ex-employee
    where(first_name: first_name, last_name:  last_name).first
  end

  def self.guess_subjects!
    Author.includes(journals: :category).find_each.map do |a|
      topics = a.journals.map do |j|
        if j.category
          j.category.name
        else
          j.guessed_category_name_from_title
        end
      end.compact.uniq

      if topics.length == 1
        category = Category.lookup topics.first
        a.update_attributes default_category: category
      end
    end
  end

  def name
    "#{first_name} #{last_name}".strip
  end
end
