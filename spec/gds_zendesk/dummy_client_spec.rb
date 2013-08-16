require 'gds_zendesk/dummy_client'

module GDSZendesk
  describe DummyClient do
    context "when a ticket has been raised" do
      let(:ticket_options) { { opt1: "val1" } }

      it "should log the ticket details" do
        logger = stub("logger")
        logger.should_receive(:info).with("Zendesk ticket created: #{ticket_options.inspect}")

        client = DummyClient.new(logger: logger)
        client.ticket.create!(ticket_options)
      end

      it "can simulate failures, triggered by a specific description or comment" do
        logger = mock("logger")
        client = DummyClient.new(logger: logger)
        logger.should_receive(:info).with(/Simulating Zendesk ticket creation failure/).twice

        lambda { 
          client.ticket.create!(description: "break_zendesk")
        }.should raise_error(ZendeskAPI::Error::RecordInvalid)
        
        lambda { 
          client.ticket.create!(comment: { value: "break_zendesk" })
        }.should raise_error(ZendeskAPI::Error::RecordInvalid)
      end
    end

    context "when a user has been created" do
      let(:created_user_options) { { email: "a@b.com" } }

      it "should log the user details" do
        logger = stub("logger")
        logger.should_receive(:info).with("Zendesk user created: #{created_user_options.inspect}")

        client = DummyClient.new(logger: logger)
        client.users.create!(created_user_options)
      end
    end
  end
end
