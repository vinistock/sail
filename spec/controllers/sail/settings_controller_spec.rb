describe Sail::SettingsController, type: :controller do
  routes { Sail::Engine.routes }
  before { Rails.cache.delete('setting_get_setting') }

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

    context 'when defining an authorization strategy' do
      before do
        Sail.configuration.dashboard_auth_lambda = -> { user_is_authorized }
      end

      after do
        Sail.configuration.dashboard_auth_lambda = nil
      end

      context 'when authorized' do
        let(:user_is_authorized) { true }

        it 'queries settings with pagination' do
          subject
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when not authorized' do
        let(:user_is_authorized) { false }

        it 'queries settings with pagination' do
          subject
          expect(response).to have_http_status(:forbidden)
        end
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

    context 'when format is JSON' do
      subject { put :update, params: { name: setting.name, value: new_value, cast_type: setting.cast_type }, format: :json }

      it 'updates setting value' do
        expect(setting.value).to eq('old value')
        subject
        expect(response).to have_http_status(:ok)
        expect(setting.reload.value).to eq('new value')
      end
    end
  end

  describe 'GET show' do
    subject { get :show, params: params, format: :json }
    let!(:setting) { Sail::Setting.create(name: :setting, cast_type: :string, value: 'some value') }
    let(:params) {{ name: setting.name }}

    it 'returns setting value' do
      subject
      body = JSON.parse(response.body)
      expect(body['value']).to eq(setting.value)
    end

    it 'returns 200 status' do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'responds in json format' do
      subject
      expect(response.content_type).to eq('application/json')
    end
  end
end
