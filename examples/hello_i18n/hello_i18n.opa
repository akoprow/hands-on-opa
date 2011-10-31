package translation_example
import stdlib.themes.bootstrap
import stdlib.web.client

supported_langs = ["zh", "en", "hu", "es", "ru", "ar", "bn", "pt", "id", "fr"]

hello =
| "zh" -> "你好"                 // Mandarin
| "en" -> "Hello"               // English
| "hu" -> "नमस्ते"                // Hindustani
| "es" -> "Hola"                // Spanish
| "ru" -> "здравствуйте"        // Russian
| "ar" -> "لسلام عليكم"         // Arabic
| "bn" -> "নমস্কার"                // Bengali
| "pt" -> "Bom dia"             // Portuguese
| "id" -> "Selamat pagi"        // Indonesian
| "fr" -> "Bonjour"             // French
| _    -> "Eee... hello?"       // default

lang_to_string =   // FIXME This should come from stdlib I18n module
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

render_lang = lang_to_string

render_sel_lang(lang) =
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
  mk_flag(code) = <img class=flag src="/resources/flags/{code}.png" />;
  <>{List.map(mk_flag, flags(lang))} {lang_to_string(lang)}</>

WI18n = {{

  @private @client set_lang(lang) =
    do I18n.set_lang(lang)
    do Client.reload()
    void

  select_lang(langs : list(I18n.language), lang_to_string, lang_to_xhtml) =
    id = Dom.fresh_id()
    change_language() = Dom.get_value(#{id}) |> set_lang
    lang_entry(lang) =
      <option value="{lang}">
        {lang_to_string(lang)}
      </>;
    <>
      {@i18n(lang_to_xhtml)} |
      <select class=span3 id={id} onchange={_ -> change_language()}>
        <option>Change language</>
        {List.map(lang_entry, langs)}
      </>
    </>

}}

page() =
  <div class=container>
    <>{WI18n.select_lang(supported_langs, render_lang, render_sel_lang)}</>
    <h1>{@i18n(hello)}</>
  </>

flags = @static_resource_directory("resources/flags")
server = Server.one_page_bundle("i18n test", [flags], [], page)

css = css
  .flag {
    margin: 0px 2px;
  }
