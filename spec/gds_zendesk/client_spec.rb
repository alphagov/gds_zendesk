require 'spec_helper'
require 'gds_zendesk/test_helpers'
require 'gds_zendesk/client'
require 'null_logger'

module GDSZendesk
  describe Client do
    include GDSZendesk::TestHelpers

    def client(options = {})
      Client.new(valid_credentials.merge(options))
    end

    let(:valid_credentials) { { username: "user", password: "pass" } }

    it "should raise an error if no username is provided" do
      lambda { Client.new(password: "abc") }.should raise_error(ArgumentError,
        /username not provided/)
    end

    it "should raise an error if no password is provided" do
      lambda { Client.new(username: "abc") }.should raise_error(ArgumentError,
        /password not provided/)
    end

    it "should use a null logger if no logger has been provided" do
      client.config_options[:logger].should be_an_instance_of(NullLogger::Logger)
    end

    it "should use the passed logger if one has been provided" do
      custom_logger = stub("logger")

      client(logger: custom_logger).config_options[:logger].should eq(custom_logger)
    end

    it "should raise tickets in Zendesk" do
      post_stub = stub_zendesk_ticket_creation(some: "data")

      client.ticket.create(some: "data")

      post_stub.should have_been_requested
    end
  end
end