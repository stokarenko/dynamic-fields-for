class Role < ActiveRecord::Base
  belongs_to :user

  validates :user, :role_name, presence: true
end
