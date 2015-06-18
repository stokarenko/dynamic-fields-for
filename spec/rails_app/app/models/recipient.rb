class Recipient
  include ActiveAttr::Model

  attribute :email

  validates :email,  presence: true
end
