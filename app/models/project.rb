class Project < ActiveRecord::Base
  # Associations
  has_many :tickets, dependent: :delete_all
  has_many :roles, dependent: :delete_all

  # Validations
  validates :name, presence: true
end
