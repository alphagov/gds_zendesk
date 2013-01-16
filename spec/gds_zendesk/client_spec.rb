require 'gds_zendesk/client'

module GDSZendesk
  describe Client do
    let(:builder) { stub("builder") }
    let(:client) { stub("client") }

    context "when configured" do
      it "should merge in defaults and pass the given options to the ClientBuilder" do
        options = { something: true }

        ClientBuilder.should_receive(:new).with(development_mode: false, something: true).and_return(builder)
        builder.should_receive(:build).and_return(client)

        Client.build(options).should eq(client)
      end
    end

    context "when not configured" do
      it "should pass default configuration to the ClientBuilder" do
        ClientBuilder.should_receive(:new).with(Client::DEFAULT_OPTIONS).and_return(builder)
        builder.should_receive(:build).and_return(client)

        Client.build.should eq(client)
      end
    end

    context "when in development mode" do
      it "should build a dummy client instead of a real Zendesk client" do
        DummyClientBuilder.should_receive(:new).with(development_mode: true).and_return(builder)
        builder.should_receive(:build).and_return(client)

        Client.build(development_mode: true).should eq(client)
      end
    end
  end
end