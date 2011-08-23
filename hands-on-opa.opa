import stdlib.widgets.{core,notification}

resources = @static_resource_directory("resources")

main_server="94.23.204.210"

show_example(ex, url_suffix) =
  Modal = WNotification
  src_code_id = "src_code"
  src_code_modal_config =
    cl(id) = {class=["src_code_{id}"]}
    { WNotification.default_config with style_box =
        { sizex = 800
        ; sizey = 500
        ; style_top = cl("top")
        ; style_content = cl("content")
        ; style_buttons = WStyler.empty
        ; style_main = cl("main")
        }
    }
  src_code_modal_box =
    xhtml =
      <a class=action href="https://github.com/akoprow/hands-on-opa/tree/master/examples/{ex.name}">
        <img src="/resources/img/github.png" />
        See on GitHub
      </>
      <a class=action href="/{ex.name}/{ex.name}.zip">
        <img src="/resources/img/download.png" />
        Download
      </>
      <span id=compile_instr>
        Compile with:
        <pre>{Examples.compilation_instructions(ex)}</>
      </>
      <div class=coming_soon>
        Source code browser coming soon...
      </>
    close(box_id) = _ -> Modal.destroy({default}, box_id)
    { Modal.default_error(xhtml) with
        title = <>Source code of the example: «{ex.name}»</>
        buttons = {customized=box_id ->
                     <span id=#src_code_close onclick={close(box_id)} />}
    }
  src_code_html =
    Modal.html(src_code_modal_config, src_code_id)
  src_code_modal_show() =
    Modal.notify(src_code_modal_config, Modal.box_id(src_code_id), src_code_modal_box)
  header =
  <>
    {src_code_html}
    <a id=#logo href="/">
      <img src="/resources/img/hands-on-opa.png" />
    </>
    <div id=#header_right>
      <a id=#opalang href="http://opalang.org">
        Go to opalang.org
      </>
      <div id=#article>
        <a href={ex.article.post} target="_blank">Article</>
      </>
      <div id=#src_code>
        <a onclick={_ -> src_code_modal_show()}>
          Source code
        </>
      </>
    </>
    <div id=#title>
      {ex.name}
    </>
  </>
  page =
    <div id="header">{header}</div>
    <div id="container">
      <iframe src="http://{main_server}:{ex.port}{url_suffix}" />
    </>
    <script src="resources/ga.js" type="text/javascript"></script>
  Resource.styled_page("Hands on Opa: {ex.name}", ["/resources/style/style.css"], page)

show_manual_article(article) =
  <li class=linkicon32-doc>
    <a target="_blank" href={article.post}>{article.title}</>
    {article.descr}
  </>

index() =
  header =
    <div id=#title>
      Hands on Opa: learn Opa by examples!
    </>
    <a id=#logo href="/">
      <img src="/resources/img/hands-on-opa.png" />
    </>
    <div id=#header_right>
      <a id=#opalang href="http://opalang.org">
        Go to opalang.org
      </>
    </>
  blog_articles = <ul></ul>
  manual_articles = <ul>{List.map(show_manual_article, manual_articles)}</ul>
  page =
    <div id="header">{header}</div>
    <div id="container">
      <div class="intro_wrap">
        <div class="intro">
          <div class="centered">
            <h1>Learn Opa... by examples!</>
            <h3>Below you'll find a number of demos/articles about Opa, both from the manual and from the blog, that will allow you to learn Opa by examples.</>
          </>
        </>
      </>
      <div class="content_wrap">
        <div class="content">
          <div class="block">
            <div class="col50 white-bg">
              <h3>Blog articles</>
              {blog_articles}
            </>
            <div class="col50 col-right white-bg">
              <h3>Examples</>
            </>
          </>
          <div class="block">
            <div class="col50 white-bg">
              <h3>Manual articles</>
              {manual_articles}
            </>
          </>
        </>
      </>
    </>
  Resource.styled_page("Hands on Opa: Opa tutorials",
    ["http://opalang.org/css/style.css", "/resources/style/style.css"], page)

urls =
  rec aux =
  | [] ->
    (parser "/" -> index())
  | [x | xs] ->
    (parser
    | "/{x.name}/{x.name}.zip" -> Examples.pack(x)
    | "/{x.name}" suffix=("/" .*)? -> show_example(x, Option.map(Text.to_string, suffix) ? "")
    | res={aux(xs)} -> res
    )
  aux(examples)

server =
  do Examples.deploy_all(examples)
  Server.simple_bundle([resources], urls)
