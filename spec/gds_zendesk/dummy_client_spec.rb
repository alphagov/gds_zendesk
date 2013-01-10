require 'gds_zendesk/dummy_client'

module GDSZendesk
  describe DummyClient do
    context "when a ticket has been raised" do
      let(:ticket_options) { { opt1: "val1" } }

      it "should log the ticket details" do
        logger = stub("logger")
        logger.should_receive(:info).with("Zendesk ticket created: #{ticket_options.inspect}")

        client = DummyClient.new(logger)
        client.ticket.create(ticket_options)
      end

      it "should return something non-null upon success" do
        client = DummyClient.new(mock("logger", :info => nil))
        client.ticket.create({}).should_not be_nil
      end

      it "should provide accessors to the ticket options for testing purposes" do
        client = DummyClient.new(mock("logger", :info => nil))
        client.ticket.create(
          subject: "A",
          description: "B",
          requester: { "locale_id" => 1, "email" => "c@d.com", "name" => "E F" },
          collaborators: "H, I, J",
          fields: [{"id" => FIELD_MAPPINGS[:needed_by_date], "value" => "19700101"},
                  {"id" => FIELD_MAPPINGS[:not_before_date], "value" => "19700102"}],
          tags: "tags",
          comment: { value: "Comment" }
        )

        client.ticket.subject.should eq("A")
        client.ticket.description.should eq("B")
        client.ticket.email.should eq("c@d.com")
        client.ticket.name.should eq("E F")
        client.ticket.collaborators.should eq("H, I, J")
        client.ticket.needed_by_date.should eq("19700101")
        client.ticket.not_before_date.should eq("19700102")
        client.ticket.tags.should eq("tags")
        client.ticket.comment.should eq("Comment")
      end

      it "can simulate failures, triggered by a specific description" do
        logger = mock("logger")
        client = DummyClient.new(logger)
        logger.should_receive(:info).with(/Simulating Zendesk ticket creation failure/)

        lambda { 
          client.ticket.create(description: "break_zendesk")
        }.should raise_error(ZendeskError)
      end

      it "can simulate failures, triggered by a setter" do
        client = DummyClient.new(mock("logger", :info => nil))
        client.ticket.should_raise_error

        lambda { client.ticket.create({}) }.should raise_error(ZendeskError)
      end
    end

    context "when a user has been created" do
      let(:created_user_options) { { email: "a@b.com" } }

      it "should log the user details" do
        logger = stub("logger")
        logger.should_receive(:info).with("Zendesk user created: #{created_user_options.inspect}")

        client = DummyClient.new(logger)
        client.users.create(created_user_options)
      end

      it "can simulate failures, triggered by a setter" do
        client = DummyClient.new(mock("logger", :info => nil))
        client.users.should_raise_error

        lambda { client.users.create({}) }.should raise_error(ZendeskError)
      end
    end
  end
end