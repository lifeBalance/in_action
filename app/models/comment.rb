class Comment < ActiveRecord::Base
  # Associations
  belongs_to :ticket
  belongs_to :author, class_name: 'User'
  belongs_to :state

  # Validations
  validates :text, presence: true

  delegate :project, to: :ticket

  # Scopes
  scope :persisted, lambda { where.not(:id => nil) }

  # Callbacks
  after_create :set_ticket_state

  private
    def set_ticket_state
      ticket.state = state
      ticket.save!
    end
end
