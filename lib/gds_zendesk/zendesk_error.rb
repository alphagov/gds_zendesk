module GDSZendesk
  class ZendeskError < StandardError
    attr_reader :underlying_error_details_from_zendesk

    def initialize(message, underlying_error_details_from_zendesk = nil)
      super(message)

      @underlying_error_details_from_zendesk = underlying_error_details_from_zendesk
    end
  end
end