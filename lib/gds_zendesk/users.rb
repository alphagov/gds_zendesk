module GDSZendesk
  class Users
    def initialize(client)
      @client = client
    end

    def create_or_update_user(requested_user)
      existing_users = find_by_email(requested_user.email)
      if existing_users.empty?
        create(requested_user)
      else
        existing_user_in_zendesk = existing_users.first
        update(existing_user_in_zendesk, requested_user)
      end
    end

    def suspended?(user_email)
      existing_users = find_by_email(user_email)
      if existing_users.empty?
        false
      else
        existing_user_in_zendesk = existing_users.first
        existing_user_in_zendesk["suspended"]
      end
    end

    protected
    def find_by_email(email)
      @client.users.search(query: email).to_a
    end

    def create(requested_user)
      @client.users.create(email: requested_user.email,
                           name: requested_user.name,
                           details: "Job title: #{requested_user.job}",
                           phone: requested_user.phone,
                           verified: true)
    end

    def update(existing_user_in_zendesk, requested_user)
      existing_user_in_zendesk.update(details: "Job title: #{requested_user.job}")
      if !requested_user.phone.nil? && !requested_user.phone.empty?
        existing_user_in_zendesk.update(phone: requested_user.phone)
      end
      existing_user_in_zendesk.save
      existing_user_in_zendesk
    end
  end
end