require 'json'

module GDSZendesk
  module TestHelpers
    def zendesk_has_no_user_with_email(email)
      stub_request(:get, "#{zendesk_endpoint}/users/search?query=#{email}").
        to_return(body: {users: [], previous_page: nil, next_page: nil, count: 0}.to_json, 
                  headers: {'Content-Type' => 'application/json'})
    end

    def zendesk_has_user(user_details)
      stub_request(:get, "#{zendesk_endpoint}/users/search?query=#{user_details[:email]}").
        to_return(body: {users: [user_details], previous_page: nil, next_page: nil, count: 1}.to_json, 
                  headers: {'Content-Type' => 'application/json'})
    end

    def stub_zendesk_user_creation(user_properties)
      stub_http_request(:post, "#{zendesk_endpoint}/users").
        with(body: {user: user_properties}).
        to_return(status: 201, body: { user: { id: 12345, name: "abc"}})
    end

    def stub_zendesk_ticket_creation(ticket_properties)
      stub_http_request(:post, "#{zendesk_endpoint}/tickets").
        with(body: {ticket: ticket_properties}).
        to_return(status: 201, body: { ticket: { id: 12345}})
    end

    def stub_zendesk_user_update(user_id, user_properties)
      stub_http_request(:put, "#{zendesk_endpoint}/users/#{user_id}").
        with(body: {user: user_properties}).
        to_return(status: 201, body: { user: { id: 12345, name: "abc"}})
    end      

    def zendesk_endpoint
      "https://#{valid_credentials[:username]}:#{valid_credentials[:password]}@govuk.zendesk.com/api/v2"
    end

    def valid_credentials
      { username: "abc", password: "def" }
    end
  end
end