require 'forwardable'
require 'null_logger'
require 'zendesk_api'

require 'gds_zendesk/users'

module GDSZendesk
  class Client
    extend Forwardable
    def_delegators :@zendesk_client, :ticket

    attr_accessor :config_options

    def initialize(config_options)
      @config_options = defaults.merge(config_options)
      @zendesk_client = build
    end

    def users
      Users.new(@zendesk_client)
    end

    def build
      check_that_username_and_password_are_provided

      ZendeskAPI::Client.new { |config|
        config.url = "https://govuk.zendesk.com/api/v2/"
        config.username = username
        config.password = password
        config.logger = logger
      }
    end

    protected
    def logger
      @config_options[:logger] || @config_options["logger"]
    end

    def check_that_username_and_password_are_provided
      raise ArgumentError, "Zendesk username not provided" if username.nil?
      raise ArgumentError, "Zendesk password not provided" if password.nil?
    end

    def username
      @config_options[:username] || @config_options["username"]
    end

    def password
      @config_options[:password] || @config_options["password"]
    end

    def defaults
      { logger: NullLogger.instance }
    end
  end
end