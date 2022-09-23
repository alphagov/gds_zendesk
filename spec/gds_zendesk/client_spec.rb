require "spec_helper"
require "gds_zendesk/test_helpers"
require "gds_zendesk/client"
require "null_logger"

module GDSZendesk
  describe Client do
    include GDSZendesk::TestHelpers

    def valid_credentials
      { "username" => "user", "password" => "pass" }
    end

    def client(options = {})
      Client.new(valid_credentials.merge(options))
    end

    it "raises an error if no username is provided" do
      expect { described_class.new(password: "abc") }.to raise_error(ArgumentError,
                                                                     /username not provided/)
    end

    it "raises an error if no password or token is provided" do
      expect { described_class.new(username: "abc") }.to raise_error(ArgumentError,
                                                                     /password or token not provided/)
    end

    it "raises an error if token and password are provided" do
      expect { described_class.new(username: "abc", token: "def", password: "ghi") }.to raise_error(ArgumentError,
                                                                                                    /Provide only one of token or password/)
    end

    it "does not raise an error if token is provided without password" do
      expect { described_class.new(username: "abc", token: "def") }.not_to raise_error
    end

    it "does not raise an error if password is provided without token" do
      expect { described_class.new(username: "abc", password: "def") }.not_to raise_error
    end

    it "uses a null logger if no logger has been provided" do
      expect(client.config_options[:logger]).to be_an_instance_of(NullLogger::Logger)
    end

    it "uses the passed logger if one has been provided" do
      custom_logger = double("logger")

      expect(client(logger: custom_logger).config_options[:logger]).to eq(custom_logger)
    end

    it "uses the default url if no url is provided" do
      expect(client.config_options[:url]).to eq "https://govuk.zendesk.com/api/v2/"
    end

    it "uses the token if provided" do
      expect(described_class.new(username: "test_user", token: "test_token").config_options[:token]).to eq "test_token"
    end

    it "uses the password if provided" do
      expect(described_class.new(username: "test_user", password: "test_password").config_options[:password]).to eq "test_password"
    end

    it "uses the configured url if provided" do
      expect(described_class.new(username: "test_user", password: "test_pass", url: "https://example.com").config_options[:url]).to eq "https://example.com"
    end

    it "raises tickets in Zendesk" do
      self.valid_zendesk_credentials = valid_credentials
      post_stub = stub_zendesk_ticket_creation(some: "data", comment: nil)

      client.ticket.create(some: "data")

      expect(post_stub).to have_been_requested
    end

    it "raises an exception if the ticket creation wasn't successful" do
      self.valid_zendesk_credentials = valid_credentials
      post_stub = stub_request(:post, "#{zendesk_endpoint}/tickets").to_return(status: 302)

      expect { client.ticket.create!(some: "data") }.to raise_error(ZendeskAPI::Error::NetworkError)
      expect(post_stub).to have_been_requested
    end
  end
end
