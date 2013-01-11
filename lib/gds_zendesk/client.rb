require 'gds_zendesk/client_builder'
require 'gds_zendesk/dummy_client_builder'

module GDSZendesk
  class Client
    DEFAULT_OPTIONS = { development_mode: false }
    @config_options = DEFAULT_OPTIONS

    class << self
      def configure(options)
        @config_options = @config_options.merge(options)
      end

      def instance
        @client ||= appropriate_builder_class.new(@config_options).build
      end

      def reset
        @client = nil
        @config_options = DEFAULT_OPTIONS
      end

      protected
      def appropriate_builder_class
        @config_options[:development_mode] ? DummyClientBuilder : ClientBuilder
      end
    end
  end
end