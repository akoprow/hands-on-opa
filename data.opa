type blog_article =
  { title : string
  ; post : Uri.uri
  }

// ===============================================================
// manual articles
// ===============================================================
mk_manual_article(~{at title}) : blog_article =
  uri = "http://opalang.org/resources/book/index.html#{at}"
  wrong_uri() = error("Wrong manual URI: {uri}")
  post = Option.lazy_default(wrong_uri, Uri.of_string(uri))
  ~{post title}

hello_chat = mk_manual_article(
  { at="_hello_chat"
  ; title="Hello, chat"
  })
hello_wiki = mk_manual_article(
  { at="_hello_wiki"
  ; title="Hello, wiki"
  })
hello_wiki_rest = mk_manual_article(
  { at="_hello_web_services"
  ; title="Hello, web services"
  })
hello_wiki_rest_client = mk_manual_article(
  { at="_hello_web_services_client"
  ; title="Hello, web services client"
  })
hello_recaptcha = mk_manual_article(
  { at="hello_recaptcha"
  ; title="Hello, reCaptcha (and the rest of the world)"
  })

// ===============================================================
// blog articles
// ===============================================================
mk_hands_on_article(~{at title}) : blog_article =
  uri = "http://blog.opalang.org/{at}"
  wrong_uri() = error("Wrong article URI: {uri}")
  post = Option.lazy_default(wrong_uri, Uri.of_string(uri))
  ~{post title}

hello_opa = mk_hands_on_article(
  { at="2011/06/hello-opa-what-is-opa-to-quote-manual.html"
  ; title="Hello Opa"
  })
hello_web = mk_hands_on_article(
  { at="2011/06/first-steps-hello-web-in-opa.html"
  ; title="First steps: \"Hello web\" in Opa"
  })
weekend_chat_1 = mk_hands_on_article(
  { at="2011/07/weekend-chat-about-opa-matthieu-guffroy.html"
  ; title="Weekend chat about Opa: Matthieu Guffroy"
  })
interactivity = mk_hands_on_article(
  { at="2011/07/interactivity-even-handling.html"
  ; title="Interactivity, event handling"
  })
questions_1 = mk_hands_on_article(
  { at="2011/07/readers-questions-1.html"
  ; title="Reader's questions #1"
  })
db_intro = mk_hands_on_article(
  { at="2011/07/very-gentle-introduction-to-db-and.html"
  ; title="(Very) gentle introduction to DB and records"
  })
weekend_chat_2 = mk_hands_on_article(
  { at="2011/07/weekend-chat-about-opa-austin-seipp.html"
  ; title="Weekend chat about Opa: Austin Seipp"
  })
challenge = mk_hands_on_article(
  { at="2011/07/opa-developer-challenge-is-on.html"
  ; title="Opa Developer Challenge is on!"
  })
image_intro = mk_hands_on_article(
  { at="2011/07/image-developing-image-viewer-in-opa.html"
  ; title="iMage: developing an image viewer in Opa"
  })
image_resources = mk_hands_on_article(
  { at="2011/07/image-part-1-dealing-with-external.html"
  ; title="iMage: part 1, Dealing with external resources"
  })
challenge_reminder = mk_hands_on_article(
  { at="2011/07/reminder-opa-developer-challenge.html"
  ; title="Reminder: Opa Developer Challenge"
  })
trx = mk_hands_on_article(
  { at="2011/07/trx-parsing-in-opa.html"
  ; title="TRX: parsing in Opa"
  })
unit_testing = mk_hands_on_article(
  { at="2011/08/unit_testing_and_parsing.html"
  ; title="More parsing and unit-testing"
  })
packages_modules = mk_hands_on_article(
  { at="2011/08/image-part-2-files-packages-modules.html"
  ; title="iMage: part 2, Files, packages, modules"
  })

// ===============================================================
// manual examples
// ===============================================================
chat =             { name="hello_chat"             port=5010 article=hello_chat             srcs=@static_include_directory("examples/hello_chat")}
wiki =             { name="hello_wiki"             port=5011 article=hello_wiki             srcs=@static_include_directory("examples/hello_wiki")}
wiki_rest =        { name="hello_wiki_rest"        port=5012 article=hello_wiki_rest        srcs=@static_include_directory("examples/hello_wiki_rest")}
wiki_rest_client = { name="hello_wiki_rest_client" port=5013 article=hello_wiki_rest_client srcs=@static_include_directory("examples/hello_wiki_rest_client")}
recaptcha =        { name="hello_recaptcha"        port=5014 article=hello_recaptcha        srcs=@static_include_directory("examples/hello_recaptcha")}

manual_examples = [ chat, wiki, wiki_rest, wiki_rest_client, recaptcha ]

// ===============================================================
// blog examples
// ===============================================================
hello =      { name="hello_web"  port=5008 article=hello_web        srcs=@static_include_directory("examples/hello_web") }
watch =      { name="watch"      port=5000 article=interactivity    srcs=@static_include_directory("examples/watch") }
watch_slow = { name="watch_slow" port=5001 article=interactivity    srcs=@static_include_directory("examples/watch_slow")}
counter =    { name="counter"    port=5002 article=db_intro         srcs=@static_include_directory("examples/counter")}
iMage =      { name="iMage"      port=5003 article=image_intro      srcs=@static_include_directory("examples/iMage")}
iMage_01 =   { name="iMage-01"   port=5004 article=image_resources  srcs=@static_include_directory("examples/iMage-01")}
iMage_02 =   { name="iMage-02"   port=5005 article=image_resources  srcs=@static_include_directory("examples/iMage-02")}
iMage_03 =   { name="iMage-03"   port=5006 article=image_resources  srcs=@static_include_directory("examples/iMage-03")}
calculator = { name="calculator" port=5007 article=unit_testing     srcs=@static_include_directory("examples/calculator") }
iMage_04 =   { name="iMage-04"   port=5009 article=packages_modules srcs=@static_include_directory("examples/iMage-04")}

blog_examples = [ hello, watch, watch_slow, counter, iMage, iMage_01, iMage_02, iMage_03, calculator, iMage_04 ]

// ===============================================================
// all examples
// ===============================================================
examples = manual_examples ++ blog_examples
