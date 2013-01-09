module GDSZendesk
  class Client
    @config_options = {}

    class << self
      def configure(options)
        @config_options = options
      end

      def instance
        @client ||= ClientBuilder.new(@config_options).build
      end

      def reset
        @client = nil
        @config_options = {}
      end
    end
  end
end