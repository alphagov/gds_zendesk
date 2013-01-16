INITIALIZER = <<END
require 'yaml'
require 'gds_zendesk/client'
require 'gds_zendesk/dummy_client'

GDS_ZENDESK_CLIENT = if Rails.env.development? || Rails.env.test?
  GDSZendesk::DummyClient.new(logger: Rails.logger)
else
  username, password = nil
  config_yaml_file = File.join(Rails.root, 'config', 'zendesk.yml')
  if File.exist?(config_yaml_file)
    config = YAML.load_file(config_yaml_file)[Rails.env]
    unless config.nil?
      username = config['username']
      password = config['password']
    end
  end
  GDSZendesk::Client.new(username: username, password: password, logger: Rails.logger)
end
END

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
