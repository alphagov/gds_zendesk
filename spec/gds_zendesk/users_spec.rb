require 'gds_zendesk/users'

module GDSZendesk
  describe Users do
    let(:stub_zendesk_users) { stub("zendesk API") }
    let(:users) { Users.new(stub("Zendesk client", users: stub_zendesk_users)) }

    context "existing users" do
      before do
        @stub_existing_zendesk_user = stub("existing zendesk user")
        stub_zendesk_users.should_receive(:search).with(query: "test@test.com").and_return([@stub_existing_zendesk_user])        
      end

      context "creating/updating a user" do
        it "should update the phone and job title if those are set" do
          @stub_existing_zendesk_user.should_receive(:update).with(details: "Job title: Developer")
          @stub_existing_zendesk_user.should_receive(:update).with(phone: "12345")
          @stub_existing_zendesk_user.should_receive(:save)

          existing_user_being_requested = stub("requested user", email: "test@test.com", phone: "12345", job: "Developer")
          users.create_or_update_user(existing_user_being_requested)
        end
      end

      it "should know whether the user is suspended or not" do
        @stub_existing_zendesk_user.should_receive(:[]).with("suspended").and_return(true)
        users.suspended?("test@test.com").should be_true
      end
    end

    context "non-existent users" do
      before do
        stub_zendesk_users.should_receive(:search).with(query: "test@test.com").and_return([])
      end

      it "should not be suspended" do
        users.suspended?("test@test.com").should be_false
      end

      context "creating/updating" do
        it "should create that user" do
          stub_zendesk_users.should_receive(:create).with(email: "test@test.com",
                                                          name: "Abc",
                                                          phone: "12345",
                                                          details: "Job title: Developer",
                                                          verified: true)

          existing_user_being_requested = stub("requested user", name: "Abc", email: "test@test.com", phone: "12345", job: "Developer")
          users.create_or_update_user(existing_user_being_requested)
        end
      end
    end
  end
end