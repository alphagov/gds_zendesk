# GDS Zendesk

> This gem was archived. The functionality was ported to [Support API](https://github.com/alphagov/support-api). 

## What is it?

`gds_zendesk` is a Ruby gem which (partially) wraps the [Zendesk REST API v2](http://developer.zendesk.com/documentation/rest_api/introduction.html).

The [zendesk_api](https://github.com/zendesk/zendesk_api_client_rb) gem is used under the covers.

## Why does it exist?

This gem has certain advantages over the `zendesk_api` gem:

*  Rails integration
*  A dummy Zendesk client implementation, since Zendesk doesn't provide a staging environment
*  Ability to simulate error conditions

## Rails integration

### Installation

Simply add the gem to your Gemfile and bundle it up:

    gem 'gds_zendesk'

Run the installation generator:

    $ rails generate gds_zendesk:install

This generates an initializer at `config/initializers/gds_zendesk.rb`.

### Configuration

#### Mandatory settings

This gem needs to be configured with a Zendesk username and password (or token)  before it can be used.
These are set in `config/initializers/gds_zendesk.rb`

#### Enabling development mode

Because Zendesk doesn't provide a staging environment, it is advised to use the development mode 
during development and testing. When this mode is enabled: 
* the real Zendesk client is replaced by an interface-equivalent dummy implementation (which makes no network calls)
* ticket creation failures can be simulated by including `break_zendesk` anywhere in the ticket description

Development mode can be enabled by configuring `development_mode: true`. It is off by default.

## Usage

Invoke

```
GDSZendesk::Client.new(config_options)
```

to create a new client.

## Running tests locally

To run the tests, use the follow:

```
bundle exec rake default
```
# Licence

[MIT License](LICENCE)
