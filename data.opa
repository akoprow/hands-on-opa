type blog_article =
  { title : string
  ; post : Uri.uri
  }

mk_hands_on_article(~{at title}) : blog_article =
  uri = "http://blog.opalang.org/{at}"
  wrong_uri() = error("Wrong article URI: {uri}")
  post = Option.lazy_default(wrong_uri, Uri.of_string(uri))
  ~{post title}

mk_example(~{name port article srcs}) = {~name ~port ~article ~srcs plugins=[]} : example

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

watch =      mk_example({ name="watch"      port=5000 article=interactivity   srcs=@static_include_directory("watch") })
watch_slow = mk_example({ name="watch_slow" port=5001 article=interactivity   srcs=@static_include_directory("watch_slow")})
counter =    mk_example({ name="counter"    port=5002 article=db_intro        srcs=@static_include_directory("counter")})
iMage =                 { name="iMage"      port=5003 article=image_intro     srcs=@static_include_directory("iMage")
  plugins=[{name="effects" files=["effects/effects.js", "effects/jquery-effects.js"]}]}
iMage_01 =   mk_example({ name="iMage-01"   port=5004 article=image_resources srcs=@static_include_directory("iMage-01")})
iMage_02 =   mk_example({ name="iMage-02"   port=5005 article=image_resources srcs=@static_include_directory("iMage-02")})
iMage_03 =   mk_example({ name="iMage-03"   port=5006 article=image_resources srcs=@static_include_directory("iMage-03")})

examples : list(example) = [ watch, watch_slow, counter, iMage, iMage_01, iMage_02, iMage_03 ]
