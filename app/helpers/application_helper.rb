module ApplicationHelper
  include Pagy::Frontend

  def full_title page_title = ""
    base_title = Settings.app.name || t("base_title")
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  # I18n helper for JavaScript
  def i18n_js_data
    {
      locale: I18n.locale,
      translations: {
        I18n.locale => {
          microposts: I18n.t("microposts"),
          date: I18n.t("date"),
          time: I18n.t("time"),
          number: I18n.t("number")
        }
      }
    }
  end
end
