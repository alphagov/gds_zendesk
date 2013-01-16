require 'forwardable'
require 'gds_zendesk/client_builder'

module GDSZendesk
  class Client
    extend Forwardable
    def_delegator :@zendesk_client, :ticket, :users

    def initialize(options)
      @zendesk_client = ClientBuilder.new(options).build
    end
  end
end