require 'null_logger'
require 'gds_zendesk/field_mappings'
require 'zendesk_api/error'

module GDSZendesk
  class DummyClient
    attr_reader :ticket, :users

    def initialize(options)
      @logger = defaults.merge(options)[:logger]
      reset
    end

    def reset
      @ticket = DummyTicket.new(@logger)
      @users = DummyUsers.new(@logger)
    end

    protected
    def defaults
      { logger: NullLogger.instance }
    end
  end

  class DummyTicket
    attr_reader :options

    def initialize(logger)
      @logger = logger
      @should_raise_error = false
    end

    def create(options)
      @options = options
      if should_raise_error?
        @logger.info("Simulating Zendesk ticket creation failure: #{options.inspect}")
        raise ZendeskAPI::Error::RecordInvalid.new(body: {"details" => "sample error message from Zendesk"})
      else
        @logger.info("Zendesk ticket created: #{options.inspect}")
      end
      @options
    end

    def should_raise_error
      @should_raise_error = true
    end

    [:subject, :tags, :description, :collaborators, :priority].each do |property|
      define_method(property) do
        @options[property]
      end
    end

    GDSZendesk::FIELD_MAPPINGS.each do |field_name, field_id|
      define_method(field_name) do
        value_of_field_with_id(field_id)
      end
    end

    def name
      @options[:requester]["name"]
    end

    def email
      @options[:requester]["email"]
    end

    def comment
      @options[:comment][:value] unless @options[:comment].nil?
    end

    protected
    def should_raise_error?
      description =~ /break_zendesk/ or comment =~ /break_zendesk/ or @should_raise_error
    end

    def value_of_field_with_id(field_id)
      correct_field = @options[:fields].detect {|field| field["id"] == field_id}
      correct_field["value"]
    end
  end

  class DummyUsers
    attr_reader :created_user_attributes

    def initialize(logger)
      @logger = logger
      @created_user_attributes = {}
      @should_raise_error = false
    end

    def should_raise_error
      @should_raise_error = true
    end

    def search(attributes)
      []
    end

    def create(new_user_attributes)
      if @should_raise_error
        @logger.info("Simulating Zendesk user creation failure: #{new_user_attributes.inspect}")
        raise ZendeskAPI::Error::RecordInvalid.new(body: {"details" => "error creating users"})
      else
        @created_user_attributes = new_user_attributes
        @logger.info("Zendesk user created: #{new_user_attributes.inspect}")
      end
    end
  end
end