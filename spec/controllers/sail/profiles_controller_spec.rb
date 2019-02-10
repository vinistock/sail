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
end
