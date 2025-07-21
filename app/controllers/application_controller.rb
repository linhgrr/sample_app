class ApplicationController < ActionController::Base
  before_action :set_locale

  private

  def set_locale
    locale = params[:locale]
    allowed_locales = I18n.available_locales.map(&:to_s)
    I18n.locale = if locale && allowed_locales.include?(locale)
                    locale
                  else
                    session[:locale] || I18n.default_locale
                  end
    session[:locale] = I18n.locale
  end
end
