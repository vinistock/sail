# frozen_string_literal: true

describe Sail::ProfilesController, type: :controller do
  routes { Sail::Engine.routes }

  describe "POST create" do
    # :nocov:
    subject(:request) do
      if Rails::VERSION::MAJOR >= 5
        post :create, params: { name: :profile }, format: :json
      else
        post :create, name: :profile, format: :json
      end
    end
    # :nocov:

    it "returns created" do
      request
      expect(response).to have_http_status(:created)
    end

    it "invokes create_or_update_self from profiles" do
      expect(Sail::Profile).to receive(:create_or_update_self).with("profile").and_call_original
      request
    end

    context "when a profile with the same name exists" do
      before do
        Sail::Profile.create!(name: :profile)
      end

      it "returns ok for an update" do
        request
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "PUT switch" do
    # :nocov:
    subject(:request) do
      if Rails::VERSION::MAJOR >= 5
        put :switch, params: { name: :profile }, format: :json
      else
        put :switch, name: :profile, format: :json
      end
    end
    # :nocov:

    it "returns ok" do
      request
      expect(response).to have_http_status(:ok)
    end

    it "invokes switch from profiles" do
      expect(Sail::Profile).to receive(:switch).with("profile")
      request
    end
  end

  describe "DELETE destroy" do
    # :nocov:
    subject(:request) do
      if Rails::VERSION::MAJOR >= 5
        delete :destroy, params: { name: :profile }, format: :json
      else
        delete :destroy, name: :profile, format: :json
      end
    end
    # :nocov:

    let!(:profile) { Sail::Profile.create!(name: :profile) }

    it "returns ok" do
      request
      expect(response).to have_http_status(:ok)
    end

    it "destroys profile" do
      expect { request }.to change(Sail::Profile, :count).by(-1)
    end
  end
end
