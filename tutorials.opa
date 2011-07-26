type blog_article =
  { title : string
  ; post : Uri.uri
  }

type example =
  { article : blog_article
  ; name : string
  ; port : int
  ; srcs : stringmap(string)
  }

mk_article(uri, title) : blog_article =
  wrong_uri() = error("Wrong article URI: {uri}")
  post = Option.lazy_default(wrong_uri, Uri.of_string(uri))
  ~{post title}

interactivity : blog_article =
  mk_article("http://blog.opalang.org/2011/07/interactivity-even-handling.html",
    "Interactivity, event handling")

image_intro : blog_article =
  mk_article("http://blog.opalang.org/2011/07/image-developing-image-viewer-in-opa.html",
    "iMage: developing an image viewer in Opa")

image_resources : blog_article =
  mk_article("http://blog.opalang.org/2011/07/image-part-1-dealing-with-external.html",
    "iMage: part 1, Dealing with external resources")

examples : list(example) = [
  {article=interactivity   name="watch"      port=5000 srcs=@static_include_directory("watch")},
  {article=interactivity   name="watch_slow" port=5001 srcs=@static_include_directory("watch_slow")},
  {article=interactivity   name="counter"    port=5002 srcs=@static_include_directory("counter")},
  {article=image_intro     name="iMage"      port=5003 srcs=@static_include_directory("iMage")},
  {article=image_resources name="iMage-01"   port=5004 srcs=@static_include_directory("iMage-01")},
  {article=image_resources name="iMage-02"   port=5005 srcs=@static_include_directory("iMage-02")},
  {article=image_resources name="iMage-03"   port=5006 srcs=@static_include_directory("iMage-03")}
  ]

show_example(ex) =
  header =
    <link href="http://fonts.googleapis.com/css?family=Kranky&v2" rel="stylesheet" type="text/css" />
    <div id=#title>
      Hands on Opa: {ex.name}
    </>
  page =
    <div id="header">{header}</div>
    <div id="container">
      <iframe src="http://94.23.204.210:{ex.port}" />
    </>
  Resource.page("Hands on Opa: {ex.name}", page)

urls =
  rec aux =
  | [] ->
    (parser .* ->
       Resource.default_error_page({wrong_address})
    )
  | [x | xs] ->
    (parser
    | "/{x.name}" -> show_example(x)
    | res={aux(xs)} -> res
    )
  aux(examples)

server = simple_server(urls)

header_height = 50.
css = css
  html, body {
    position: absolute;
    height: 100%;
    max-height: 100%;
    width: 100%;
    margin: 0;
    padding: 0;
  }
  iframe {
    position: absolute;
    height: 100%;
    width: 100%;
    border: none;
  }
  #container {
    position: absolute;
    top: {px(header_height + 5.)};
    bottom: 0;
    width: 100%;
    overflow: hidden;
  }
  #header {
    position: absolute;
    top: 0px;
    height: {px(header_height)};
    width: 100%;
    background: black;
    color: #CCC;
    border-bottom: 1px solid #ECECEC;
    border-top: 3px solid #FF9238;
    box-shadow: 0 0 5px #AAA;
  }
  #title {
    font: normal bold 30px Kranky;
    padding: 8px;
    float: left;
  }
