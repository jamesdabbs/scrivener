class Category < ActiveRecord::Base
  attr_accessor :guessed, :from

  validates_presence_of :remote_id, :name

  def self.sync! teamwork
    teamwork.categories.each do |remote|
      where(remote_id: remote.fetch('id')).first_or_create! do |c|
        c.name      = remote.fetch 'name'
        c.parent_id = remote.fetch 'parent-id'
      end
    end
  end

  def self.lookup name
    # FIXME: this should probably fetch from a cache
    # FIXME: I don't trust remote_ids now ... see Author.lookup
    return unless name.present?
    where(name: name).first!
  end
end
