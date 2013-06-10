require 'gds_zendesk/client'
require 'null_logger'

module GDSZendesk
  describe Client do
    let(:valid_credentials) { { username: "user", password: "pass" } }

    it "should raise an error if no username is provided" do
      options = { password: "abc" }

      lambda { Client.new(options) }.should raise_error(ArgumentError,
                                                        /username not provided/)
    end

    it "should raise an error if no password is provided" do
      options = { username: "abc" }

      lambda { Client.new(options) }.should raise_error(ArgumentError,
                                                        /password not provided/)
    end

    it "should use a null logger if no logger has been provided" do
      Client.new(valid_credentials).config_options[:logger].should be_an_instance_of(NullLogger::Logger)
    end

    it "should use the passed logger if one has been provided" do
      custom_logger = stub("logger")

      Client.new(valid_credentials.merge(logger: custom_logger)).config_options[:logger].should eq(custom_logger)
    end

    it "should provide access to the underlying ZendeskAPI::Client#ticket and #users method" do
      underlying_client = mock("ZendeskAPI::Client", ticket: "ticket", users: "users")
      underlying_client.stub!(:insert_callback)
      ZendeskAPI::Client.stub!(:new).and_return(underlying_client)

      Client.new(valid_credentials).ticket.should == "ticket"
      Client.new(valid_credentials).users.should == "users"
    end
  end
end