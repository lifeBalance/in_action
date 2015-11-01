class Project < ActiveRecord::Base
  # Associations
  has_many :tickets

  # Validations
  validates :name, presence: true
end
