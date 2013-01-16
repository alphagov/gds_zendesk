module GDSZendesk
  class Railtie < Rails::Railtie
    config.gds_zendesk = ActiveSupport::OrderedOptions.new
  end
end