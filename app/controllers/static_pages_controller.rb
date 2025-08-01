class StaticPagesController < ApplicationController
  # GET / (root)
  # GET /static_pages/home
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @pagy, @feed_items = pagy current_user.feed, items: Settings.page_10
  end

  # GET /static_pages/help
  def help
    @support_email = Settings.email.support
    @help_link = Settings.links.help
    @book_link = Settings.links.book
  end

  # GET /static_pages/contact
  def contact
    @contact_email = Settings.email.support
    @app_name = Settings.app.name
    @user_name = params[:name] || Settings.app.default_user_name
  end
end
