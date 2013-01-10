# GDS Zendesk

This gem wraps parts of the Zendesk API functionality to make it a bit friendlier to use.

Features:

* Rails integration
* A dummy Zendesk client implementation, since Zendesk doesn't provide a staging environment

## Installation

Simply add the gem to your Gemfile and bundle it up:

    gem 'gds_zendesk'

Run the installation generator:

    $ rails generate gds_zendesk:install

This generates an initializer at `config/initializers/gds_zendesk.rb`.

## Configuration

### Mandatory settings

This gem needs to be configured with a Zendesk username and password before it can be used.

*  **Within Rails** - adjust the settings in `config/initializers/gds_zendesk.rb`
*  **Outside Rails** - make the following call:
   
   ```
   GDSZendesk::Client.configure(
     username: [...]
     password: [...]
   )
   ```

### Enabling development mode

Because Zendesk doesn't provide a staging environment, it is advised to use the development mode 
during development and testing. When this mode is enabled: 
* the real Zendesk client is replaced by an interface-equivalent dummy implementation (which makes no network calls)
* ticket creation failures can be simulated by including `break_zendesk` anywhere in the ticket description

Development mode can be enabled by configuring `development_mode: true`. It is off by default.


