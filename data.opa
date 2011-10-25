type article =
  { title : string
  ; post : Uri.uri
  ; descr : xhtml
  ; article_type : {manual_chapter} / {blog_post : {image} / {tutorial} / {discussion} / {weekend_chat} / {questions} / {announcement}}
  }

// ===============================================================
// manual articles
// ===============================================================
mk_manual_article(~{at title descr}) : article =
  uri = "http://opalang.org/resources/book/index.html#{at}"
  wrong_uri() = error("Wrong manual URI: {uri}")
  post = Option.lazy_default(wrong_uri, Uri.of_string(uri))
  ~{post title descr=<>{descr}</> article_type={manual_chapter}}

intro_opa = mk_manual_article(
  { at="_introducing_opa"
  ; title="Introducing Opa"
  ; descr="What is Opa. What is it good for. What web development problems does it address."
  })
getting_opa = mk_manual_article(
  { at="Getting_Opa"
  ; title="Getting Opa"
  ; descr="How to install Opa. How to build it from sources."
  })
hello_chat = mk_manual_article(
  { at="_hello_chat"
  ; title="Hello, chat"
  ; descr="How does communication, concurrency and distribution work. Real-time distributed web chat in just a screenful of Opa."
  })
hello_wiki = mk_manual_article(
  { at="_hello_wiki"
  ; title="Hello, wiki"
  ; descr="How to persist data. Developing a simple wiki."
  })
hello_wiki_rest = mk_manual_article(
  { at="_hello_web_services"
  ; title="Hello, web services"
  ; descr="How to develop REST services."
  })
hello_wiki_rest_client = mk_manual_article(
  { at="_hello_web_services_client"
  ; title="Hello, web services client"
  ; descr="How to access a REST service."
  })
hello_scalability = mk_manual_article(
  { at="_hello_scalability"
  ; title="Hello, scalability"
  ; descr="Distribution and load balancing, i.e. why scalability is easy with Opa"
  })
hello_recaptcha = mk_manual_article(
  { at="hello_recaptcha"
  ; title="Hello, reCaptcha (and the rest of the world)"
  ; descr="How to access external APIs. Using Google's reCaptcha service."
  })
core_language = mk_manual_article(
  { at="_the_core_language"
  ; title="The core language"
  ; descr="Overview of the core Opa language."
  })
developing_web = mk_manual_article(
  { at="_developing_for_the_web"
  ; title="Developing for the web"
  ; descr="Aspects and extensions of the language crucial for web development."
  })
the_database = mk_manual_article(
  { at="_the_database"
  ; title="The Database"
  ; descr="Storage and persistence features of Opa"
  })
running_executables = mk_manual_article(
  { at="_running_executables"
  ; title="Running Executables"
  ; descr="Overview of the compiler, auxiliary tools and deployment of Opa apps."
  })
filename_extensions = mk_manual_article(
  { at="_filename_extensions"
  ; title="Appendix A: Filename extensions"
  ; descr="Common file extensions and their use in the Opa ecosystem."
  })
bindings = mk_manual_article(
  { at="_bindings_with_other_languages"
  ; title="Appendix B: Bindings with other languages"
  ; descr="How to use libraries in JavaScript, Ocaml or C. Foreign function interface of Opa."
  })
type_system = mk_manual_article(
  { at="The_type_system"
  ; title="Appendix C: The type system"
  ; descr="Overview of Opa's type system"
  })

manual_articles = [ intro_opa, getting_opa, hello_chat, hello_wiki, hello_wiki_rest, hello_wiki_rest_client, hello_scalability, hello_recaptcha, core_language, developing_web, the_database, running_executables, filename_extensions, bindings, type_system ]

// ===============================================================
// blog articles
// ===============================================================
mk_hands_on_article(~{at title descr ty}) : article =
  uri = "http://blog.opalang.org/{at}"
  wrong_uri() = error("Wrong article URI: {uri}")
  post = Option.lazy_default(wrong_uri, Uri.of_string(uri))
  ~{post title ~descr article_type={blog_post=ty}}

hello_opa = mk_hands_on_article(
  { at="2011/06/hello-opa-what-is-opa-to-quote-manual.html"
  ; title="Hello Opa"
  ; descr=<>Blog introduction. What is Opa. And why it rocks.</>
  ; ty={discussion}
  })
hello_web = mk_hands_on_article(
  { at="2011/06/first-steps-hello-web-in-opa.html"
  ; title="First steps: \"Hello web\" in Opa"
  ; descr=<>A bit about Opa's syntax. Basics of HTML manipulation in Opa. Basics of main entry points of Opa programs. How to compile your first Opa program. How to deploy it (also on many machines).</>
  ; ty={tutorial}
  })
weekend_chat_1 = mk_hands_on_article(
  { at="2011/07/weekend-chat-about-opa-matthieu-guffroy.html"
  ; title="Weekend chat about Opa: Matthieu Guffroy"
  ; descr=<>Matthieu tells about his experience with Opa while writing <a href="https://github.com/mattgu74/OpaCms">OpaCms</a>.</>
  ; ty={weekend_chat}
  })
interactivity = mk_hands_on_article(
  { at="2011/07/interactivity-even-handling.html"
  ; title="Interactivity, event handling"
  ; descr=<>How to handle events in Opa and write interactive apps. How application distribution works in Opa.</>
  ; ty={tutorial}
  })
questions_1 = mk_hands_on_article(
  { at="2011/07/readers-questions-1.html"
  ; title="Reader's questions #1"
  ; descr=<></>
  ; ty={questions}
  })
db_intro = mk_hands_on_article(
  { at="2011/07/very-gentle-introduction-to-db-and.html"
  ; title="(Very) gentle introduction to DB and records"
  ; descr=<>Basics of Opa persistency. Basics of Opa records.</>
  ; ty={tutorial}
  })
weekend_chat_2 = mk_hands_on_article(
  { at="2011/07/weekend-chat-about-opa-austin-seipp.html"
  ; title="Weekend chat about Opa: Austin Seipp"
  ; descr=<>Austin speaks about his experience of developing <a href="https://github.com/thoughtpolice/opaque">opaque</a> -- a simple, markdown-powered blog engine</>
  ; ty={weekend_chat}
  })
challenge = mk_hands_on_article(
  { at="2011/07/opa-developer-challenge-is-on.html"
  ; title="Opa Developer Challenge is on!"
  ; descr=<>Take part in Opa Developer Challenge and win awesome prizes.</>
  ; ty={announcement}
  })
image_intro = mk_hands_on_article(
  { at="2011/07/image-developing-image-viewer-in-opa.html"
  ; title="iMage: developing an image viewer in Opa"
  ; descr=<>Announcing iMage and its upcoming walk-through on the blog.</>
  ; ty={image}
  })
image_resources = mk_hands_on_article(
  { at="2011/07/image-part-1-dealing-with-external.html"
  ; title="iMage: part 1, Dealing with external resources"
  ; descr=<>The basics of Opa templating. How to handle external resources, such as images, in your app. How to work with CSS.</>
  ; ty={image}
  })
challenge_reminder = mk_hands_on_article(
  { at="2011/07/reminder-opa-developer-challenge.html"
  ; title="Reminder: Opa Developer Challenge"
  ; descr=<></>
  ; ty={announcement}
  })
trx = mk_hands_on_article(
  { at="2011/07/trx-parsing-in-opa.html"
  ; title="TRX: parsing in Opa"
  ; descr=<>About Parsing Expressions Grammars (PEGs). How to handle string parsing in Opa.</>
  ; ty={tutorial}
  })
unit_testing = mk_hands_on_article(
  { at="2011/08/more-parsing-and-unit-testing.html"
  ; title="More parsing and unit-testing"
  ; descr=<>More details about parsing. How to do unit-testing.</>
  ; ty={tutorial}
  })
image_structuring = mk_hands_on_article(
  { at="2011/08/image-part-2-files-packages-modules.html"
  ; title="iMage: part 2, Files, packages, modules"
  ; descr=<>About files, packages and modules in Opa. How to split bigger projects into logical components.</>
  ; ty={image}
  })
image_parsing = mk_hands_on_article(
  { at="2011/08/image-part-3-parsing-external.html"
  ; title="iMage: part 3, Parsing external configuration"
  ; descr=<>How to put into practice previously obtained skills of writing parsers. How to change application behavior, based on the accessed URL. How to have more than one server declaration.</>
  ; ty={image}
  })
license_contribs = mk_hands_on_article(
  { at="2011/08/opa-license-contributions.html"
  ; title="Opa: license, contributions"
  ; descr=<>About Opa's license and how to contribute to the project.</>
  ; ty={discussion}
  })
bootstrap = mk_hands_on_article(
  { at="2011/08/bootstrap-in-opa-hello-dear-readers.html"
  ; title="\"Hello Bootstrap\" in Opa"
  ; descr=<>An article describing how to use Twitter's Bootstrap in Opa.</>
  ; ty={discussion}
  })
sessions = mk_hands_on_article(
  { at="2011/09/sessions-handling-state-communication.html"
  ; title="Sessions: Opa's communication mechanism"
  ; descr=<>About state encapsulation using sessions. About event-driven style of programming with sessions. How communication is accomplished in Opa.</>
  ; ty={tutorial}
  })
unit_conv=mk_hands_on_article(
  { at="2011/09/units-of-measurement-handling-custom.html"
  ; title="Units of measurement: handling custom types"
  ; descr=<>How to use custom types in a transparent way in your UI, design UI components, separate application logic from user interface and reduce client-server communication with the onready event.</>
  ; ty={tutorial}
  })
unit_conv_plus=mk_hands_on_article(
  { at="2011/09/units-of-measurement-improving-ux.html"
  ; title="Units of measurement: improving UX"
  ; descr=<>More about useful UI design patterns. How to create reactive apps. How to boost their looks with Bootstrap.</>
  ; ty={tutorial}
  })
licence_again=mk_hands_on_article(
  { at="2011/09/opa-license-strikes-again.html"
  ; title="Opa license strikes again"
  ; descr=<>Announcing free proprietary Opa license.</>
  ; ty={discussion}
  })
i18n=mk_hands_on_article(
  { at=""
  ; title="Parlez vous Opa?"
  ; descr=<>How to create multilingual sites with Opa. And how to do so in a translators-friendly manner.</>
  ; ty={tutorial}
  })
forms=mk_hands_on_article(
  { at=""
  ; title="Handling forms in Opa"
  ; descr=<>How to create and handle forms.</>
  ; ty={tutorial}
  })

blog_articles = [hello_opa, hello_web, weekend_chat_1, interactivity, questions_1, db_intro, weekend_chat_2, challenge, image_intro, image_resources, challenge_reminder, trx, unit_testing, image_structuring, image_parsing, license_contribs, bootstrap, sessions, unit_conv, unit_conv_plus, licence_again, i18n ]

// ===============================================================
// manual examples
// ===============================================================
chat_descr = <p>A web chat application (in 20 LOC!).</><p>Learn how communication works in Opa.</>
wiki_descr = <p>A simple wiki application</><p>Learn how to safely use user-defined content in your app.</>
wiki_r_descr = <p>A variant of the wiki application, accessible via a REST API.</><p>Learn how to design REST web services and manage URI queries.</>
wiki_rc_descr = <p>A variant of the wiki application, using the REST wiki as its back-end.</><p>Learn how to access distant REST services and how to handle command-line arguments to programs.</>
recaptcha_descr = <p>A simple app show-casing use of Google's <a target="_blank" href="http://recaptcha.net">reCaptcha API</></><p>Learn how to plug-in external APIs to Opa via its Binding System Library (BSL).</>

chat : example =             { details={descr=chat_descr deps=[]}      name="hello_chat"             port=5010 article=some(hello_chat)             srcs=@static_include_directory("examples/hello_chat")}
wiki : example =             { details={descr=wiki_descr deps=[]}      name="hello_wiki"             port=5011 article=some(hello_wiki)             srcs=@static_include_directory("examples/hello_wiki")}
wiki_rest : example =        { details={descr=wiki_r_descr deps=[]}    name="hello_wiki_rest"        port=5012 article=some(hello_wiki_rest)        srcs=@static_include_directory("examples/hello_wiki_rest")}
wiki_rest_client : example = { details={descr=wiki_rc_descr deps=[]}   name="hello_wiki_rest_client" port=5013 article=some(hello_wiki_rest_client) srcs=@static_include_directory("examples/hello_wiki_rest_client")}
recaptcha : example =        { details={descr=recaptcha_descr deps=[]} name="hello_recaptcha"        port=5014 article=some(hello_recaptcha)        srcs=@static_include_directory("examples/hello_recaptcha")}

manual_examples = [ chat, wiki, wiki_rest, wiki_rest_client, recaptcha ]

// ===============================================================
// blog examples
// ===============================================================
hello_descr = <p>The simplest «Hello web» program.</><p>Learn the basics first.</>
watch_descr = <p>A program showing current time, updated every second.</><p>Learn how client code is generated automatically from Opa.</>
counter_descr = <p>A simple button counting all its presses since the inception of the program.</><p>Learn how persistence (database) works in Opa.</>
iMage_descr = <p>A configurable image viewer</><p>Learn how to build complex UI interfaces and use external configuration for your apps.</>
calc_descr = <p>A simple calculator.</><p>Learn how to do parsing in Opa.</>
watch_fr_descr = <p>A variant of the «timer» program using an 'HTML fragment' abstraction.</><p>Learn how to use sessions to hold state and program event-based updates</>
units_descr = <p>A simple converter for length units</><p>Learn how to: use custom types in a transparent way in your UI, design UI components, separate application logic from user interface and reduce client-server communication with the onready event.</>
i18n_descr = <p>Example showing how to translate Opa apps to other languages and how to allow users to choose their preferred language.</>
hello_forms_descr = <p>Example showing how to develop forms with Opa.</>

hello : example=       { name="hello_web"           port=5008 article=some(hello_web)         srcs=@static_include_directory("examples/hello_web")           details={descr=hello_descr deps=[]}}
watch : example =      { name="watch"               port=5000 article=some(interactivity)     srcs=@static_include_directory("examples/watch")               details={descr=watch_descr deps=[]}}
watch_slow : example = { name="watch_slow"          port=5001 article=some(interactivity)     srcs=@static_include_directory("examples/watch_slow")          details={invisible}}
counter : example =    { name="counter"             port=5002 article=some(db_intro)          srcs=@static_include_directory("examples/counter")             details={descr=counter_descr deps=[]}}
iMage_01 : example =   { name="iMage-01"            port=5004 article=some(image_resources)   srcs=@static_include_directory("examples/iMage-01")            details={invisible}}
iMage_02 : example =   { name="iMage-02"            port=5005 article=some(image_resources)   srcs=@static_include_directory("examples/iMage-02")            details={invisible}}
iMage_03 : example =   { name="iMage-03"            port=5006 article=some(image_resources)   srcs=@static_include_directory("examples/iMage-03")            details={invisible}}
calculator : example = { name="calculator"          port=5007 article=some(unit_testing)      srcs=@static_include_directory("examples/calculator")          details={descr=calc_descr deps=[]}}
iMage_04 : example =   { name="iMage-04"            port=5009 article=some(image_structuring) srcs=@static_include_directory("examples/iMage-04")            details={invisible}}
iMage_05 : example =   { name="iMage-05"            port=5015 article=some(image_parsing)     srcs=@static_include_directory("examples/iMage-05")            details={invisible}}
iMage : example =      { name="iMage"               port=5003 article=some(image_intro)       srcs=@static_include_directory("examples/iMage")               details={descr=iMage_descr deps=[iMage_01, iMage_02, iMage_03, iMage_04, iMage_05]}}
watch_fr : example =   { name="watch_fragment"      port=5016 article=some(sessions)          srcs=@static_include_directory("examples/watch_fragment")      details={descr=watch_fr_descr deps=[]}}
units : example =      { name="unit_converter"      port=5017 article=some(unit_conv)         srcs=@static_include_directory("examples/unit_converter")      details={invisible}}
units_plus : example = { name="unit_converter_plus" port=5018 article=some(unit_conv_plus)    srcs=@static_include_directory("examples/unit_converter_plus") details={descr=units_descr deps=[units]}}
hello_i18n : example = { name="hello_i18n"          port=5019 article=none                    srcs=@static_include_directory("examples/hello_i18n")          details={descr=i18n_descr deps=[]}}
hello_forms :example = { name="hello_forms"         port=5028 article=none                    srcs=@static_include_directory("examples/hello_forms")         details={descr=hello_forms_descr deps=[]}}

blog_examples = [ hello, watch, watch_slow, counter, iMage, iMage_01, iMage_02, iMage_03, calculator, iMage_04, iMage_05, watch_fr, units, units_plus, hello_i18n, hello_forms ]

// ===============================================================
// all examples
// ===============================================================
examples : list(example) = blog_examples ++ manual_examples
//examples = [hello]
