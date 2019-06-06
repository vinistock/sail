class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
    random_setting = Sail::Setting.pluck(:name)
    5.times { Sail.get(random_setting.sample) }
  end
end
