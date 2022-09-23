require "spec_helper"

require "gds_zendesk/client"
require "gds_zendesk/users"
require "gds_zendesk/test_helpers"

module GDSZendesk
  describe Users do
    include GDSZendesk::TestHelpers

    let(:users) { Client.new(valid_zendesk_credentials).users }

    context "existing users" do
      before do
        zendesk_has_user(email: "test@test.com", id: 123)
      end

      context "creating/updating a user" do
        it "updates the phone and job title if those are set" do
          stub_post = stub_zendesk_user_update(123, phone: "12345", details: "Job title: Developer")
          users.create_or_update_user(double("requested user", email: "test@test.com", phone: "12345", job: "Developer"))

          expect(stub_post).to have_been_requested
        end
      end

      it "knows whether the user is suspended or not" do
        zendesk_has_user(email: "test@test.com", id: 123, suspended: "true")
        expect(users).to be_suspended("test@test.com")
      end
    end

    context "non-existent users" do
      before do
        zendesk_has_no_user_with_email("test@test.com")
      end

      it "is not suspended" do
        expect(users).not_to be_suspended("test@test.com")
      end

      context "creating/updating" do
        it "creates that user" do
          stub_post = stub_zendesk_user_creation(
            verified: true,
            name: "Abc",
            email: "test@test.com",
            phone: "12345",
            details: "Job title: Developer",
          )
          user_being_requested = double("requested user",
                                        name: "Abc", email: "test@test.com", phone: "12345", job: "Developer")

          users.create_or_update_user(user_being_requested)
          expect(stub_post).to have_been_requested
        end
      end
    end
  end
end
