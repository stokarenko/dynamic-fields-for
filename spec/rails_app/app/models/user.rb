class User < ActiveRecord::Base
  has_many :roles

  validates :user_name, presence: true
end
