class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  def index
    random_setting = Sail::Setting.pluck(:name)
    5.times { Sail.get(random_setting.sample) }
  end

  protected

  def set_locale
    I18n.locale = params[:locale] || :en
  end
end
