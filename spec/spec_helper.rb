require "webmock/rspec"
require "simplecov"
SimpleCov.start

WebMock.disable_net_connect!(allow_localhost: true)
