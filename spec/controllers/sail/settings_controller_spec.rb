describe Sail::SettingsController, type: :controller do
  routes { Sail::Engine.routes }

  describe 'GET index' do
    subject { get :index, params: { page: '1' } }

    it 'queries settings with pagination' do
      expect(Sail::Setting).to receive(:paginated).with('1')
      subject
      expect(response).to have_http_status(:ok)
    end
  end
end
