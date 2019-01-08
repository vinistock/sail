# frozen_string_literal: true

describe Sail::SettingsController, type: :controller do
  routes { Sail::Engine.routes }
  before { Rails.cache.delete("setting_get_setting") }

  describe "GET index" do
    # :nocov:
    subject do
      if Rails::VERSION::MAJOR >= 5
        get :index, params: params
      else
        get :index, params
      end
    end
    # :nocov:

    let(:params) { { page: "1" } }

    before do
      Sail::Setting.create(name: :setting, cast_type: :string, value: :something)
    end

    it "queries settings with pagination" do
      expect(Sail::Setting).to receive(:paginated).with("1")
      subject
      expect(response).to have_http_status(:ok)
    end

    it "sets eTag in response headers" do
      subject
      expect(response.headers["ETag"]).to_not be_nil
    end

    it "sets the number of pages" do
      subject
      expect(controller.instance_variable_get(:@number_of_pages)).to eq(1)
    end

    context "when passing a query" do
      let(:params) { { query: "test" } }

      it "invokes proper scope with query" do
        expect(Sail::Setting).to receive(:by_name).with("test").and_call_original
        subject
      end
    end
  end

  describe "PUT update" do
    # :nocov:
    subject do
      if Rails::VERSION::MAJOR >= 5
        put :update, params: { name: setting.name, value: new_value, cast_type: setting.cast_type }, format: :js
      else
        put :update, name: setting.name, value: new_value, cast_type: setting.cast_type, format: :js
      end
    end
    # :nocov:

    let!(:setting) { Sail::Setting.create(name: :setting, cast_type: :string, value: "old value") }
    let(:new_value) { "new value" }

    it "updates setting value" do
      expect(setting.value).to eq("old value")
      subject
      expect(response).to have_http_status(:ok)
      expect(setting.reload.value).to eq("new value")
    end

    context "when setting is boolean" do
      let!(:setting) { Sail::Setting.create(name: :setting, cast_type: :boolean, value: "false") }
      let(:new_value) { "on" }

      it "updates setting value" do
        expect(setting.value).to eq("false")
        subject
        expect(response).to have_http_status(:ok)
        expect(setting.reload.value).to eq("true")
      end
    end

    context "when format is JSON" do
      # :nocov:
      subject do
        if Rails::VERSION::MAJOR >= 5
          put :update, params: { name: setting.name, value: new_value, cast_type: setting.cast_type }, format: :json
        else
          put :update, name: setting.name, value: new_value, cast_type: setting.cast_type, format: :json
        end
      end
      # :nocov:

      it "updates setting value" do
        expect(setting.value).to eq("old value")
        subject
        expect(response).to have_http_status(:ok)
        expect(setting.reload.value).to eq("new value")
      end
    end
  end

  describe "GET show" do
    # :nocov:
    subject do
      if Rails::VERSION::MAJOR >= 5
        get :show, params: params, format: :json
      else
        get :show, params.merge(format: :json)
      end
    end
    # :nocov:

    let!(:setting) { Sail::Setting.create(name: :setting, cast_type: :string, value: "some value") }
    let(:params) { { name: setting.name } }

    it "returns setting value" do
      subject
      body = JSON.parse(response.body)
      expect(body["value"]).to eq(setting.value)
    end

    it "returns 200 status" do
      subject
      expect(response).to have_http_status(:ok)
    end

    it "responds in json format" do
      subject
      expect(response.content_type).to eq("application/json")
    end
  end

  describe "GET switcher" do
    # :nocov:
    subject do
      if Rails::VERSION::MAJOR >= 5
        get :switcher, params: params, format: :json
      else
        get :switcher, params.merge(format: :json)
      end
    end
    # :nocov:

    let!(:throttle) { Sail::Setting.create(name: :throttle, cast_type: :throttle, value: "50.0") }
    let(:params) { { positive: :positive, negative: :negative, throttled_by: :throttle } }

    before do
      Rails.cache.delete("setting_get_positive")
      Rails.cache.delete("setting_get_negative")
      Rails.cache.delete("setting_get_throttle")
      Sail::Setting.create!(name: :positive, cast_type: :string, value: "I'm the primary!")
      Sail::Setting.create!(name: :negative, cast_type: :integer, value: "7")
      allow(Sail::Setting).to receive(:rand).and_return(random_value)
    end

    context "when random value is smaller than throttle" do
      let(:random_value) { 0.25 }

      it "returns ok status" do
        subject
        expect(response).to have_http_status(:ok)
      end

      it "returns value of positive setting" do
        subject

        body = JSON.parse(response.body)
        expect(body["value"]).to eq("I'm the primary!")
      end
    end

    context "when random value is greater than throttle" do
      let(:random_value) { 0.75 }

      it "returns ok status" do
        subject
        expect(response).to have_http_status(:ok)
      end

      it "returns value of negative setting" do
        subject

        body = JSON.parse(response.body)
        expect(body["value"]).to eq(7)
      end
    end

    context "when throttle setting is of the wrong type" do
      let!(:throttle) { Sail::Setting.create!(name: :throttle, cast_type: :boolean, value: "true") }
      let(:random_value) { 0.75 }

      it "returns bad request" do
        subject
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when throttle setting does not exist" do
      let!(:throttle) { Sail::Setting.create!(name: :wrong_name, cast_type: :boolean, value: "true") }
      let(:random_value) { 0.75 }

      it "returns not found" do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PUT reset" do
    # :nocov:
    subject do
      if Rails::VERSION::MAJOR >= 5
        put :reset, params: { name: setting.name }, format: :js
      else
        put :reset, name: setting.name, format: :js
      end
    end
    # :nocov:

    let!(:setting) { Sail::Setting.create(name: :setting, cast_type: :string, value: "old value") }
    let(:file_contents) { { "setting" => { "value" => "new value" } } }

    before do
      allow(File).to receive(:exist?)
      allow(Sail::Setting).to receive(:config_file_path).and_return("./config/sail.yml")
      allow(File).to receive(:exist?).with("./config/sail.yml").and_return(true)
      allow(YAML).to receive(:load_file).with("./config/sail.yml").and_return(file_contents)
    end

    it "resets setting value" do
      expect(Sail::Setting).to receive(:reset).with("setting").and_call_original
      subject
      expect(response).to have_http_status(:ok)
      expect(setting.reload.value).to eq("new value")
    end
  end
end
