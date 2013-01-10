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

### Enabling a dummy Zendesk client (development mode)

Because Zendesk doesn't provide a staging environment, you might want to use a dummy client during development.

This can be enabled by setting `development_mode: true`. Development is off by default.

## Dummy Zendesk Implementation

Ticket creation failures can be simulated by including `break_zendesk` anywhere in the ticket description.