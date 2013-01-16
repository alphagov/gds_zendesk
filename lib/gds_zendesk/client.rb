require 'gds_zendesk/client_builder'
require 'gds_zendesk/dummy_client_builder'

module GDSZendesk
  class Client
    DEFAULT_OPTIONS = { development_mode: false }

    class << self
      def build(options = {})
        options_with_defaults = default_options.merge(options)
        appropriate_builder_class = options[:development_mode] ? DummyClientBuilder : ClientBuilder
        client_builder = appropriate_builder_class.new(options_with_defaults)
        client_builder.build
      end

      protected
      def default_options
        if defined?(Rails)
          DEFAULT_OPTIONS.merge(Rails.application.config.gds_zendesk.to_hash)
        else
          DEFAULT_OPTIONS
        end
      end
    end
  end
end