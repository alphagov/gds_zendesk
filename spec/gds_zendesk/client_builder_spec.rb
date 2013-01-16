require 'gds_zendesk/client_builder'
require 'gds_zendesk/zendesk_error'
require 'null_logger'

module GDSZendesk
  describe ClientBuilder do
    it "should raise an error if no username is provided" do
      options = { password: "abc" }

      lambda { ClientBuilder.new(options).build }.should raise_error(ArgumentError,
                                                                     /username not provided/)
    end

    it "should raise an error if no password is provided" do
      options = { username: "abc" }

      lambda { ClientBuilder.new(options).build }.should raise_error(ArgumentError,
                                                                     /password not provided/)
    end

    it "should use a null logger if no logger has been provided" do
      ClientBuilder.new({}).config_options[:logger].should be_an_instance_of(NullLogger::Logger)
    end

    it "should use the passed logger if one has been provided" do
      custom_logger = stub("logger")

      ClientBuilder.new(logger: custom_logger).config_options[:logger].should eq(custom_logger)
    end

    context "upon a response from the Zendesk API" do
      let(:custom_logger) { stub("logger").as_null_object }
      let(:builder) { ClientBuilder.new(logger: custom_logger) }

      context "a successful response from zendesk" do
        it "should log the respose" do
          successful_response = { status: 200, body: "OK" }
          custom_logger.should_receive(:info).with(successful_response)

          builder.callback[successful_response]
        end
      end

      context "a response that the request isn't authorised" do
        it "should raise an error" do
          lambda {
            builder.callback[status: 401, body: {"error" => "Unauth" }] 
          }.should raise_error(ZendeskError, /Authentication Error/)
        end
      end

      context "a response that the account has been locked out" do
        it "should raise an error" do
          response = { status: 403, body: "Too many failed login attempts for user ..." }
          lambda { builder.callback[response]}.should raise_error(ZendeskError, 
                                                                  /Authentication Error/)
        end
      end

      context "a response that some zendesk validation failed" do
        it "should raise an error" do
          response = { status: 422, body: {"error" => "Some validation failure" } }
          lambda { builder.callback[response]}.should raise_error(ZendeskError, 
                                                                  /Error creating ticket/)
        end
      end
    end
  end
end