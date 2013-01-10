require 'null_logger'
require 'gds_zendesk/dummy_client_builder'

module GDSZendesk
  describe DummyClientBuilder do
    it "should build a dummy client" do
      DummyClientBuilder.new.build.should be_an_instance_of(DummyClient)
    end

    it "should pass a null logger to the dummy client, by default" do
      DummyClient.should_receive(:new).with(instance_of(NullLogger::Logger))

      DummyClientBuilder.new.build
    end

    it "should pass a logger through to the dummy client, if one is set" do
      logger = mock("logger")
      DummyClient.should_receive(:new).with(logger)

      DummyClientBuilder.new(logger: logger).build
    end
  end
end