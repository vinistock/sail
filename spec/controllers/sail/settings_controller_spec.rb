describe Sail::SettingsController, type: :controller do
  routes { Sail::Engine.routes }

  describe 'GET index' do
    subject { get :index, params: { page: '1' } }

    it 'queries settings with pagination' do
      expect(Sail::Setting).to receive(:paginated).with('1')
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'sets eTag in response headers' do
      subject
      expect(response.headers['ETag']).to_not be_nil
    end
  end

  describe 'PUT update' do
    subject { put :update, params: { name: setting.name, value: 'new value' }, format: :js }
    let!(:setting) { Sail::Setting.create(name: :setting, cast_type: :string, value: 'old value') }

    it 'updates setting value' do
      expect(setting.value).to eq('old value')
      subject
      expect(response).to have_http_status(:no_content)
      expect(setting.reload.value).to eq('new value')
    end
  end
end
