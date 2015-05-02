class User < ActiveRecord::Base
  has_many :roles

  accepts_nested_attributes_for :roles, allow_destroy: true

  validates :user_name, presence: true
end
