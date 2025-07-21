class StaticPagesController < ApplicationController
  def home
    @app_name = Settings.app.name
    @app_version = Settings.app.version
    @registration_enabled = Settings.features.registration
  end

  def help
    @support_email = Settings.email.support
    @help_link = Settings.links.help
    @book_link = Settings.links.book
  end

  def contact
    @contact_email = Settings.email.support
    @app_name = Settings.app.name
    @user_name = params[:name] || Settings.app.default_user_name
  end
end
