require 'gds_zendesk/client'

module GDSZendesk
  describe Client do
    let(:builder) { stub("builder") }
    let(:client) { stub("client") }

    it "should pass options to ClientBuilder and build a client" do
      options = { something: true }

      ClientBuilder.should_receive(:new).with(something: true).and_return(builder)
      builder.should_receive(:build).and_return(client)

      Client.new(options)
    end
  end
end