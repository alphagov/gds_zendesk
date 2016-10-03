# 2.3.0

* Add a test helper to stub Zendesk returning a 302

# 2.2.0

* Allow the zendesk URL to be specified in the configuration

# 2.1.0

* Add test helper to stub Zendesk returning a 409

# 2.0.0

* Removed: GDSZendesk::FIELD_MAPPINGS.
* Fixed DummyUsers to behave like the real Users class.

# 1.0.5

* Update the `zendesk_api` library to v1.8.0 (this picks up a bugfix for
ticket creation succeeding when the API returns a redirect - see
https://github.com/zendesk/zendesk_api_client_rb/pull/236)

# 1.0.4

* Update the `zendesk_api` library to v1.6.3 (to keep up to date)

# 1.0.3

* Update the `zendesk_api` library to the latest version (1.5.1)
