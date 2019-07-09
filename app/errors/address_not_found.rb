class AddressNotFound < RuntimeError
  attr_reader :messages

  def initialize(messages)
    super()
    @messages = messages
  end
end