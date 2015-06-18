class EmailForm
  include ActiveAttr::Model

  attribute :recipients, type: Object, default: []

  def recipients_attributes=(attributes)
    self.recipients = attributes.values.map{ |attrs| recipients_soft_build(attrs) }
  end

  def recipients_soft_build(attrs = {})
    Recipient.new(attrs)
  end

end
