require 'gds_zendesk/client'

module GDSZendesk
  class Railtie < Rails::Railtie
    config.gds_zendesk = ActiveSupport::OrderedOptions.new

    initializer "gds_zendesk.configure" do |app|
      GDSZendesk::Client.configure app.config.gds_zendesk.to_hash
    end
  end
end