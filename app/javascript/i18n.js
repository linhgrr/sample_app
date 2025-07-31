import { I18n } from "i18n-js"

const i18n = new I18n()

window.setupI18n = function(translations, locale) {
  i18n.store(translations)
  i18n.locale = locale
  window.I18n = i18n
}

export default i18n
