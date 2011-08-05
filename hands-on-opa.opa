import stdlib.widgets.{core,notification}

resources = @static_resource_directory("resources")

main_server="94.23.204.210"

show_example(ex) =
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
      <iframe src="http://{main_server}:{ex.port}" />
    </>
  Resource.styled_page("Hands on Opa: {ex.name}", ["/resources/style/style.css"], page)

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
  page =
    <div id="header">{header}</div>
    <div id="container">
      <div class=coming_soon>
        An index page with all articles and tutorials coming soon...
      </>
    </>
  Resource.styled_page("Hands on Opa: Opa tutorials",
    ["/resources/style/style.css"], page)

urls =
  rec aux =
  | [] ->
    (parser "/" -> index())
  | [x | xs] ->
    (parser
    | "/{x.name}/{x.name}.zip" -> Examples.pack(x)
    | "/{x.name}" -> show_example(x)
    | res={aux(xs)} -> res
    )
  aux(examples)

server =
  do Examples.deploy_all(examples)
  Server.simple_bundle([resources], urls)
