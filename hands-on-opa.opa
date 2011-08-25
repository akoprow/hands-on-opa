import stdlib.widgets.{core,notification}

resources = @static_resource_directory("resources")

main_server="94.23.204.210"

example_page(ex, url_suffix) =
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

show_article(article) =
  icon =
    match article.article_type with
    | {manual_chapter} -> "document"
    | {blog_post=bp} ->
        match bp with
        | {image} -> "image"
        | {tutorial} -> "wrench"
        | {discussion} -> "users"
        | {weekend_chat} -> "messages"
        | {questions} -> "help"
        | {announcement} -> "clipboard"
  <li>
    <span class="icon32 icon-{icon}"></>
    <a target="_blank" href={article.post}>{article.title}</>
    {article.descr}
  </>

unique_articles(l) =
  rec aux(acc, l) =
    match l with
    | [] -> acc
    | [x | xs] ->
      if List.mem(x, acc) then
        aux(acc, xs)
      else
        aux([x | acc], xs)
  aux([], List.rev(l))

@client learn_action(id)(_) =
  _ = Dom.transition(#{id},
    Dom.Effect.with_duration({slow}, Dom.Effect.toggle()))
  void

show_example(ex : example) =
  match ex.details with
  | {invisible} -> none
  | ~{deps descr} ->
    articles_id = Dom.fresh_id()
    screen =
      fn = "resources/img/screenshot/{ex.name}.png"
      default = "resources/img/screenshot/default.png"
      if Map.mem(fn, resources) then
        fn
      else
        default
    dep_arts = List.map(_.article, deps) |> unique_articles
    show_article_short(article) = <a href={article.post}>{article.title}</>
    show_article(article) =
      prefix =
        match article.article_type with
        | {manual_chapter} -> <>manual chapter</>
        | {blog_post=_} -> <>blog post</>
      res = <>{prefix} {show_article_short(article)}</>
      res
    show_dep(dep) = <li>{show_article_short(dep)}</>
    learn =
      match deps with
      | [] -> <>This example is explained in the {show_article(ex.article)}</>
      | _ -> <>This example is introduced in the {show_article(ex.article)} and then further explained in the following ones:<ol>{List.map(show_dep, dep_arts)}</></>
    xhtml =
      run = "http://tutorials.opalang.org/{ex.name}"
      <article class="opalang_apps">
        <a target="_blank" href="{run}">
          <img src="{screen}" class="opalang_apps_screenshot" />
        </>
        <div class="opalang_apps_content">
          <div class="opalang_apps_title">
            <a target="_blank" href="{run}">{ex.name}</>
          </>
          <div class="opalang_apps_descr">
            {descr}
          </>
          <div class="opalang_apps_source">
            <a target="_blank" class="button" href="{run}">Run</>
            <a target="_blank" class="button" onclick={learn_action(articles_id)}>Learn</>
          </>
          <div class="opalang_apps_learn clear hidden" id={articles_id}>
            {learn}
          </>
        </>
      </>
    some(xhtml)

index_page() =
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
  blog_articles = <ul>{List.map(show_article, blog_articles)}</ul>
  manual_articles = <ul>{List.map(show_article, manual_articles)}</ul>
  examples = List.filter_map(show_example, examples)
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
            <div class="col50 white-bg fl-left">
              <h3>Blog articles</>
              {blog_articles}
            </>
            <div class="col50 white-bg fl-right">
              <h3>Examples</>
              {examples}
            </>
            <div class="col50 white-bg fl-left">
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
    (parser "/" -> index_page())
  | [x | xs] ->
    (parser
    | "/{x.name}/{x.name}.zip" -> Examples.pack(x)
    | "/{x.name}" suffix=("/" .*)? -> example_page(x, Option.map(Text.to_string, suffix) ? "")
    | res={aux(xs)} -> res
    )
  aux(examples)

server =
  do Examples.deploy_all(examples)
  Server.simple_bundle([resources], urls)
