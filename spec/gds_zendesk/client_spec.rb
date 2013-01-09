require 'gds_zendesk/client'

module GDSZendesk
  describe Client do
    before do
      Client.reset
    end

    let(:builder) { stub("builder") }
    let(:client) { stub("client") }

    context "when configured" do
      it "should pass the given options to the ClientBuilder" do
        options = stub("options")

        ClientBuilder.should_receive(:new).with(options).and_return(builder)
        builder.should_receive(:build).and_return(client)

        Client.configure(options)
        Client.instance.should eq(client)
      end
    end

    context "when not configured" do
      it "should pass an empty hash to the ClientBuilder" do
        ClientBuilder.should_receive(:new).with({}).and_return(builder)
        builder.should_receive(:build).and_return(client)

        Client.instance.should eq(client)
      end
    end

    it "should memoize the client" do
      ClientBuilder.should_receive(:new).with({}).once.and_return(builder)
      builder.should_receive(:build).once.and_return(client)

      2.times { Client.instance }
    end
  end
end