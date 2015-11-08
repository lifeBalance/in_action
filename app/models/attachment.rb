class Attachment < ActiveRecord::Base
  belongs_to :ticket

  # CarrierWave
  mount_uploader :file, AttachmentUploader
end
