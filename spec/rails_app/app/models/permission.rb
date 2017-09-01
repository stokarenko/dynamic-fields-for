class Permission < ActiveRecord::Base
  belongs_to :role

  validates :role, :permission_name, presence: true
end
