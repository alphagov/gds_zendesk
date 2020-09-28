INITIALIZER = <<~RUBY.freeze
  require 'yaml'
  require 'gds_zendesk/client'
  require 'gds_zendesk/dummy_client'
  
  GDS_ZENDESK_CLIENT = if Rails.env.development? || Rails.env.test?
    GDSZendesk::DummyClient.new(logger: Rails.logger)
  else
    config_yaml_file = File.join(Rails.root, 'config', 'zendesk.yml')
    config = YAML.load_file(config_yaml_file)[Rails.env]
    GDSZendesk::Client.new(username: config['username'], password: config['password'], token: config['token'], logger: Rails.logger)
  end
RUBY

# This module name is slightly differently capitalised to the main library module
# The reason for this is that the module name is used by Rails within the
# generator CLI tools, and the tools get confused if the module is called GDSZendesk
module GdsZendesk
  class InstallGenerator < Rails::Generators::Base
    def create_initializer_file
      initializer "gds_zendesk.rb", INITIALIZER
    end
  end
end
