class Ticket < ActiveRecord::Base
  # Associations
  belongs_to :project
  belongs_to :author, class_name: 'User'

  # Validations
  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 10 }

  # CarrierWave
  mount_uploader :attachment, AttachmentUploader
end
