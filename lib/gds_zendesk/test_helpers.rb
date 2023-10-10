require "json"

module GDSZendesk
  module TestHelpers
    def zendesk_has_no_user_with_email(email)
      stub_request(:get, "#{zendesk_endpoint}/users/search?query=#{email}")
        .with(basic_auth: basic_auth_credentials)
        .to_return(body: { users: [], previous_page: nil, next_page: nil, count: 0 }.to_json,
                   headers: { "Content-Type" => "application/json" })
    end

    def zendesk_has_user(user_details)
      stub_request(:get, "#{zendesk_endpoint}/users/search?query=#{user_details[:email]}")
        .with(basic_auth: basic_auth_credentials)
        .to_return(body: { users: [user_details], previous_page: nil, next_page: nil, count: 1 }.to_json,
                   headers: { "Content-Type" => "application/json" })
    end

    def stub_zendesk_user_creation(user_properties = nil)
      stub = stub_request(:post, "#{zendesk_endpoint}/users")
      stub.with(body: { user: user_properties }) unless user_properties.nil?
      stub.with(basic_auth: basic_auth_credentials)
      stub.to_return(status: 201, body: { user: { id: 12_345, name: "abc" } }.to_json,
                     headers: { "Content-Type" => "application/json" })
    end

    def stub_zendesk_ticket_creation(ticket_properties = nil)
      stub = stub_request(:post, "#{zendesk_endpoint}/tickets")
      stub.with(body: { ticket: ticket_properties }) unless ticket_properties.nil?
      stub.with(basic_auth: basic_auth_credentials)
      stub.to_return(status: 201, body: { ticket: { id: 12_345 } }.to_json,
                     headers: { "Content-Type" => "application/json" })
    end

    def stub_zendesk_ticket_creation_with_body(body)
      stub_request(:post, "#{zendesk_endpoint}/tickets")
        .with(body: body)
        .with(basic_auth: basic_auth_credentials)
        .to_return(status: 201, body: { ticket: { id: 12_345 } }.to_json,
                   headers: { "Content-Type" => "application/json" })
    end

    def stub_zendesk_user_update(user_id, user_properties)
      stub_request(:put, "#{zendesk_endpoint}/users/#{user_id}")
        .with(body: { user: user_properties })
        .with(basic_auth: basic_auth_credentials)
        .to_return(status: 201, body: { user: { id: 12_345, name: "abc" } }.to_json,
                   headers: { "Content-Type" => "application/json" })
    end

    def basic_auth_credentials
      [valid_zendesk_credentials["username"], valid_zendesk_credentials["password"]]
    end

    def zendesk_is_unavailable
      stub_request(:any, /#{zendesk_endpoint}\/.*/).to_return(status: 503)
    end

    def zendesk_returns_conflict
      stub_request(:any, /#{zendesk_endpoint}\/.*/).to_return(status: 409)
    end

    def zendesk_returns_redirect
      stub_request(:any, /#{zendesk_endpoint}\/.*/).to_return(status: 302)
    end

    def zendesk_endpoint
      "https://govuk.zendesk.com/api/v2"
    end

    def valid_zendesk_credentials=(credentials)
      @zendesk_credentials = credentials
    end

    def valid_zendesk_credentials
      @zendesk_credentials || { "username" => "abc", "password" => "def" }
    end

    def assert_created_ticket_has(ticket_options)
      assert_requested :post, %r{/api/v2/tickets},
                       body: { ticket: hash_including(ticket_options) }, times: 1
    end

    def assert_created_ticket_has_requester(requester_options)
      assert_requested :post, %r{/api/v2/tickets},
                       body: { ticket: hash_including(requester: hash_including(requester_options)) }, times: 1
    end
  end
end
