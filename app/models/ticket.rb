class Ticket < ActiveRecord::Base
  # Associations
  belongs_to :project
  belongs_to :author, class_name: 'User'
  has_many :attachments, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank
  has_many :comments, dependent: :destroy
  belongs_to :state

  # Validations
  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 10 }

end
