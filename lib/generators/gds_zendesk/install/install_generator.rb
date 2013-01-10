INITIALIZER = <<END
require 'yaml'

#{Rails.application.class.name}.configure do |app|
  app.config.gds_zendesk.logger = Rails.logger

  config_yaml_file = File.join(Rails.root, 'config', 'zendesk.yml')
  if File.exist?(config_yaml_file)
    config = YAML.load_file(config_yaml_file)[Rails.env]
    app.config.gds_zendesk.username = config['username']
    app.config.gds_zendesk.password = config['password']
  end
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
