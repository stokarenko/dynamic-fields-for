class Role < ActiveRecord::Base
  belongs_to :user

  has_many :permissions, inverse_of: :role

  accepts_nested_attributes_for :permissions, allow_destroy: true

  validates :user, :role_name, presence: true
end
