require 'null_logger'
require 'gds_zendesk/dummy_client'

module GDSZendesk
  class DummyClientBuilder
    attr_accessor :config_options

    def initialize(config_options = {})
      @config_options = defaults.merge(config_options)
    end

    def build
      DummyClient.new(@config_options[:logger])
    end

    protected
    def defaults
      { logger: NullLogger.instance }
    end
  end
end