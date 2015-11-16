class Ticket < ActiveRecord::Base
  # Associations
  belongs_to :project
  belongs_to :author, class_name: 'User'
  has_many :attachments, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank
  has_many :comments, dependent: :destroy
  belongs_to :state
  has_and_belongs_to_many :tags, uniq: true

  # Virtual attributes
  attr_accessor :tag_names

  # Validations
  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 10 }

  # Callbacks
  before_create :assign_default_state

  def tag_names=(names)
    @tag_names = names
    names.split.each do |name|
      self.tags << Tag.find_or_initialize_by(name: name)
    end
  end

  private
    def assign_default_state
      self.state ||= State.default
    end

end
