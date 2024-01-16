require "spec_helper"

require "gds_zendesk/client"
require "gds_zendesk/users"
require "gds_zendesk/test_helpers"

# rubocop:disable RSpec/VerifiedDoubles -- It's unclear that the user classes can be verified doubles
module GDSZendesk
  describe Users do
    include GDSZendesk::TestHelpers

    let(:users) { Client.new(valid_zendesk_credentials).users }

    context "when there is an existing user" do
      before do
        zendesk_has_user(email: "test@test.com", id: 123)
      end

      it "can update the user" do
        stub_post = stub_zendesk_user_update(123, phone: "12345", details: "Job title: Developer")
        users.create_or_update_user(double("requested user", email: "test@test.com", phone: "12345", job: "Developer"))

        expect(stub_post).to have_been_requested
      end

      it "can update a user which doesn't respond to #job" do
        stub_post = stub_zendesk_user_update(123, phone: "12345")
        users.create_or_update_user(double("requested user", email: "test@test.com", phone: "12345"))

        expect(stub_post).to have_been_requested
      end

      it "knows whether the user is suspended or not" do
        zendesk_has_user(email: "test@test.com", id: 123, suspended: "true")
        expect(users).to be_suspended("test@test.com")
      end
    end

    context "when a user doesn't exist" do
      let(:expected_attributes) do
        {
          verified: true,
          name: "Abc",
          email: "test@test.com",
          phone: "12345",
          details: "Job title: Developer",
        }
      end

      before do
        zendesk_has_no_user_with_email("test@test.com")
      end

      it "doesn't have any suspended users" do
        expect(users).not_to be_suspended("test@test.com")
      end

      it "can create that user" do
        stub_post = stub_zendesk_user_creation(expected_attributes)
        user_being_requested = double("requested user", {
          name: "Abc", email: "test@test.com", phone: "12345", job: "Developer"
        })

        users.create_or_update_user(user_being_requested)
        expect(stub_post).to have_been_requested
      end

      it "can create that user which doesn't respond to #job" do
        stub_post = stub_zendesk_user_creation(expected_attributes.except(:details))
        user_being_requested = double("requested user", {
          name: "Abc", email: "test@test.com", phone: "12345"
        })

        users.create_or_update_user(user_being_requested)
        expect(stub_post).to have_been_requested
      end
    end
  end
end
# rubocop:enable RSpec/VerifiedDoubles
