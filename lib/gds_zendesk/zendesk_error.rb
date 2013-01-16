module GDSZendesk
  class ZendeskError < StandardError
    attr_reader :underlying_message

    def initialize(message, underlying_message = nil)
      super(message)

      @underlying_message = underlying_message
    end
  end
end