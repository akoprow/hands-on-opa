import stdlib.themes.bootstrap
import stdlib.web.client

supported_langs = ["zh", "en", "hu", "es", "ru", "ar", "bn", "pt", "id", "fr"]

hello =
| "zh" -> "Ni hao"              // Mandarin
| "en" -> "Hello"               // English
| "hu" -> "Namaste"             // Hindustani
| "es" -> "Hola"                // Spanish
| "ru" -> "Zdravstvuite"        // Russian
| "ar" -> "Al salaam a’alaykum" // Arabic
| "bn" -> "Ei Je"               // Bengali
| "pt" -> "Bom dia"             // Portuguese
| "id" -> "Selamat pagi"        // Indonesian
| "fr" -> "Bonjour"             // French
| _    -> "Eee... hello?"       // default

lang_to_string =
| "zh" -> "Mandarin"
| "en" -> "English"
| "hu" -> "Hindu"
| "es" -> "Spanish"
| "ru" -> "Russian"
| "ar" -> "Arabic"
| "bn" -> "Bengali"
| "pt" -> "Portuguese"
| "id" -> "Indonesian"
| "fr" -> "French"
| s -> error("lang_to_string({s}) = ???")

lang_to_xhtml(lang) = <>{lang_to_string(lang)}</>

selected_lang_to_xhtml(lang) =
  flags =
  | "zh" -> ["cn"]
  | "en" -> ["gb", "us"]
  | "hu" -> ["in"]
  | "es" -> ["es"]
  | "ru" -> ["ru"]
  | "ar" -> ["ar"]
  | "bn" -> ["bd"]
  | "pt" -> ["pt"]
  | "id" -> ["id"]
  | "fr" -> ["fr"]
  | _    -> []
  mk_flag(code) = <img src="/resources/flags/{code}.png" />;
  <>{List.map(mk_flag, flags(lang))} {lang_to_string(lang)}</>

WI18n = {{

  @private @client set_lang(lang) =
    do I18n.set_lang(lang)
    do Client.reload()
    void

  select_lang(langs : list(I18n.language),
              render_sel : I18n.language -> xhtml,
              render_opt : I18n.language -> xhtml) =
    id = Dom.fresh_id()
    sel_lang = I18n.lang()
    change_language() =
      lang = Dom.get_value(#{id})
      set_lang(lang)
    lang_entry(lang) =
      opt =
        <option value="{lang}">
          {render_opt(lang)}
        </>
      if lang == sel_lang then
        Xhtml.add_attribute("selected", "", opt)
      else
        opt
    <>
      {render_sel(sel_lang)}
      <select id={id} onchange={_ -> change_language()}>
        {"Change language"}
        {List.map(lang_entry, langs)}
      </>
    </>

}}

page() =
  <>{WI18n.select_lang(supported_langs, selected_lang_to_xhtml, lang_to_xhtml)}</>
  <h1>{@i18n(hello)}</>

flags = @static_resource_directory("resources/flags")
server = Server.one_page_bundle("i18n test", [flags], [], page)

