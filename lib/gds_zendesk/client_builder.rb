require 'null_logger'
require 'zendesk_api'

require 'gds_zendesk/zendesk_error'

module GDSZendesk
  class ClientBuilder
    attr_accessor :config_options

    def initialize(config_options)
      @config_options = defaults.merge(config_options)
    end

    def callback(env)
      logger.info env
      
      status_401 = env[:status].to_s.start_with? "401"
      too_many_login_attempts = env[:body].to_s.start_with? "Too many failed login attempts"
      
      raise ZendeskError.new("Authentication Error: #{env.inspect}", env[:body]) if status_401 || too_many_login_attempts
      
      raise ZendeskError.new("Error creating ticket: #{env.inspect}", env[:body]) if env[:body]["error"]
    end

    def build
      check_that_username_and_password_are_provided

      client = ZendeskAPI::Client.new { |config|
        config.url = "https://govuk.zendesk.com/api/v2/"
        config.username = @config_options[:username]
        config.password = @config_options[:password]
        config.logger = @config_options[:logger]
      }

      client.insert_callback { |env| callback(env) }

      client
    end

    protected
    def logger
      @config_options[:logger]
    end

    def check_that_username_and_password_are_provided
      raise ArgumentError, "Zendesk username not provided" if @config_options[:username].nil?
      raise ArgumentError, "Zendesk password not provided" if @config_options[:password].nil?
    end

    def defaults
      { logger: NullLogger.instance }
    end
  end
end