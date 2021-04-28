require "forwardable"
require "null_logger"
require "zendesk_api"

require "gds_zendesk/users"

module GDSZendesk
  class Client
    extend Forwardable
    def_delegators :@zendesk_client, :ticket

    attr_accessor :config_options
    attr_reader :zendesk_client

    def initialize(config_options)
      @config_options = defaults.merge(config_options)
      @zendesk_client = build
    end

    def users
      Users.new(@zendesk_client)
    end

    def build
      check_that_username_and_password_are_provided

      ZendeskAPI::Client.new do |config|
        config.url = url
        config.username = username
        config.token = token if token
        config.password = password if password
        config.logger = logger
      end
    end

  protected

    def logger
      @config_options[:logger] || @config_options["logger"]
    end

    def check_that_username_and_password_are_provided
      raise ArgumentError, "Zendesk username not provided" if username.nil?
      raise ArgumentError, "Zendesk password or token not provided" if password.nil? && token.nil?
      raise ArgumentError, "Provide only one of token or password" unless password.nil? || token.nil?
    end

    def username
      @config_options[:username] || @config_options["username"]
    end

    def token
      @config_options[:token] || @config_options["token"]
    end

    def password
      @config_options[:password] || @config_options["password"]
    end

    def url
      @config_options[:url] || @config_options["url"]
    end

    def defaults
      {
        logger: NullLogger.instance,
        url: "https://govuk.zendesk.com/api/v2/",
      }
    end
  end
end
