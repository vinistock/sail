# frozen_string_literal: true

describe Sail::ProfilesController, type: :controller do
  routes { Sail::Engine.routes }

  describe "POST create" do
    subject(:request) { post :create, params: { name: :profile }, format: :json }

    it "returns created" do
      request
      expect(response).to have_http_status(:created)
    end

    it "invokes create_self from profiles" do
      expect(Sail::Profile).to receive(:create_self).with("profile")
      request
    end

    context "when a profile with the same name exists" do
      before do
        Sail::Profile.create!(name: :profile)
      end

      it "returns conflict" do
        request
        expect(response).to have_http_status(:conflict)
      end
    end
  end

  describe "PUT switch" do
    subject(:request) { put :switch, params: { name: :profile }, format: :json }

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
    subject(:request) { delete :destroy, params: { name: :profile }, format: :json }

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
