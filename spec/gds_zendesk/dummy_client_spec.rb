require "gds_zendesk/dummy_client"

module GDSZendesk
  describe DummyClient do
    context "when a ticket has been raised" do
      let(:ticket_options) { { opt1: "val1" } }

      it "should log the ticket details" do
        logger = double("logger")
        expect(logger).to receive(:info).with("Zendesk ticket created: #{ticket_options.inspect}")

        client = DummyClient.new(logger: logger)
        client.ticket.create!(ticket_options)
      end

      it "can simulate failures, triggered by a specific description or comment" do
        logger = double("logger")
        client = DummyClient.new(logger: logger)
        expect(logger).to receive(:info).with(/Simulating Zendesk ticket creation failure/).twice

        expect {
          client.ticket.create!(description: "break_zendesk")
        }.to raise_error(ZendeskAPI::Error::RecordInvalid)

        expect {
          client.ticket.create!(comment: { value: "break_zendesk" })
        }.to raise_error(ZendeskAPI::Error::RecordInvalid)
      end
    end

    context "when a user has been created" do
      let(:options) { { email: "a@b.com" } }

      it "should log the user details" do
        logger = double("logger")
        expect(logger).to receive(:info).with("Zendesk user created or updated: #{options.inspect}")

        client = DummyClient.new(logger: logger)
        client.users.create_or_update_user(options)
      end
    end
  end
end
