# 3.7.1

* Update dependencies

# 3.7.1

* Update dependencies

# 3.7.1

* Update dependencies

# 3.7.1

* Update dependencies

# 3.7.1

* Update dependencies

# 3.7.1

* Update dependencies

# 3.7.1

* Update dependencies

# 3.7.1

* Update dependencies

# 3.7.1

* Update dependencies

# 3.7.1

* Update dependencies

# 3.7.1

* Update dependencies

# 3.7.1

* Update dependencies

# 3.7.1

* Update dependencies

# 3.7.1

* Update dependencies

# 3.7.1

* Update dependencies

# 3.7.1

* Update dependencies

# 3.7.0

* Drop support for Ruby 3.0.

# 3.6.0

* Don't require requested user object to respond to `#job` or `#phone` in calls to `Users#create_or_update_user`

# 3.5.0

* Add support for `zendesk_api` v3.x

# 3.4.0

* Drop support for Ruby 2.7 and below.
* Require a `zendesk_api` of ">= 1.37", "< 3.0"

# 3.3.0

* Allow access to Zendesk::Client from GDSZendesk::Client

# 3.2.0

* Allow use of a token instead of password

# 3.1.0

* Update `zendesk_api` library to v1.27

# 3.0.0

* Update the `webmock` library to version v2.3.2 to be compatible with Ruby
2.4.2
* Update the `test_helpers` to be compatible with `webmock` v2.3.2

# 2.4.0

* Update the `zendesk_api` library to v1.14.4 to silence warnings from
Hashie about setting a key called `class`.

# 2.3.1

* Patch release as the previous upgrade didn't include the required
  feature due to rapid successive merges.

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
