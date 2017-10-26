# frozen_string_literal: true
describe Sail::ClustersController, type: :controller do
  routes { Sail::Engine.routes }

  describe 'GET new' do
    subject { get :new }

    it 'returns status ok' do
      subject
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET report' do
    subject { get :report }

    it 'returns status ok' do
      subject
      expect(response).to have_http_status(:ok)
    end
  end
end
