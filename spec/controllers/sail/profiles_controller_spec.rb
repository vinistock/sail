# frozen_string_literal: true

describe Sail::ProfilesController, type: :controller do
  routes { Sail::Engine.routes }

  describe "POST create" do
    subject(:request) do
      post :create, params: { name: "profile" }, format: :js
    end

    it "returns ok" do
      request
      expect(response).to have_http_status(:ok)
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
    subject(:request) do
      put :switch, params: { name: "profile" }, format: :js
    end

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
    subject(:request) do
      delete :destroy, params: { name: "profile" }, format: :js
    end

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
