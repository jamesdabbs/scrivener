class Hook < ActiveRecord::Base
  validates_presence_of :source, :payload

  serialize :payload, JSON

  def perform!
  end
end
