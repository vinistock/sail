# frozen_string_literal: true
describe Sail::ClustersController, type: :controller do
  routes { Sail::Engine.routes }

  describe 'GET new' do
    subject { get :new }

    it 'returns status ok and sets models' do
      subject
      expect(response).to have_http_status(:ok)
      expect(assigns(:models)).to eq(%w(Namespace::MyModel Test))
    end
  end

  describe 'GET report' do
    subject { get :report }

    it 'returns status ok' do
      subject
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET columns' do
    subject { get :columns, params: params, format: :json }

    context 'when not passing a model' do
      let(:params) { { } }

      it 'returns bad request with error message' do
        subject
        expect(response).to have_http_status(:bad_request)
        expect(response.body). to eq('param is missing or the value is empty: model')
      end
    end

    context 'when passing a model' do
      let(:params) { { model: 'Test' } }

      it 'returns status ok' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq("[\"Name\",\"Value\",\"Real\",\"Content\"]")
      end
    end
  end
end
