describe Sail::SettingsController, type: :controller do
  routes { Sail::Engine.routes }

  describe 'GET index' do
    subject { get :index, params: params }
    let(:params) {{ page: '1' }}

    it 'queries settings with pagination' do
      expect(Sail::Setting).to receive(:paginated).with('1')
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'sets eTag in response headers' do
      subject
      expect(response.headers['ETag']).to_not be_nil
    end

    context 'when passing a query' do
      let(:params) {{ query: 'test' }}

      it 'invokes proper scope with query' do
        expect(Sail::Setting).to receive(:by_name).with('test').and_call_original
        subject
      end
    end
  end

  describe 'PUT update' do
    subject { put :update, params: { name: setting.name, value: new_value, cast_type: setting.cast_type }, format: :js }
    let!(:setting) { Sail::Setting.create(name: :setting, cast_type: :string, value: 'old value') }
    let(:new_value) { 'new value' }

    it 'updates setting value' do
      expect(setting.value).to eq('old value')
      subject
      expect(response).to have_http_status(:ok)
      expect(setting.reload.value).to eq('new value')
    end

    context 'when setting is boolean' do
      let!(:setting) { Sail::Setting.create(name: :setting, cast_type: :boolean, value: 'false') }
      let(:new_value) { 'on' }

      it 'updates setting value' do
        expect(setting.value).to eq('false')
        subject
        expect(response).to have_http_status(:ok)
        expect(setting.reload.value).to eq('true')
      end
    end
  end

  describe 'GET show' do
    subject { get :show, params: { name: setting.name }, xhr: true }
    let!(:setting) { Sail::Setting.create(name: :setting, cast_type: :string, value: 'value') }

    it 'returns the requested setting' do
      subject
      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body).to eql({ 'value' => setting.value, 'name' => setting.name })
    end
  end
end
