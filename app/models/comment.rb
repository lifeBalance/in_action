class Comment < ActiveRecord::Base
  # Associations
  belongs_to :ticket
  belongs_to :author, class_name: 'User'

  # Validations
  validates :text, presence: true

  delegate :project, to: :ticket

  # Scopes
  scope :persisted, lambda { where.not(:id => nil) }
end
