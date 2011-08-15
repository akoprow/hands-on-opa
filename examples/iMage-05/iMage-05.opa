import stdlib.web.template
import mlstate.image.slideshow

resources_css = @static_resource_directory("resources")
default_config = @static_content("resources/img-data-thefuturebuzz.txt")
footer = @static_content("footer.xmlt")

show_page(content) =
  title = "iMage: a magical image viewer!"
  style = ["resources/css.css"]
  Resource.styled_page(title, style, content) |> some

show_slideshow(slideshow_config : WSlideshow.config) =
  footer =
    Template.parse(Template.default, footer())
    |> Template.to_xhtml(Template.default, _)
  xhtml =
    <>
      {WSlideshow.html(slideshow_config)}
      {footer}
    </>
  show_page(xhtml)

show_error(error) =
 show_page(<div class=error>{error}</>)

go(config_string) =
  match Parser.try_parse(WSlideshow.markup_parser, config_string)
  | {none} -> show_error(
                <>
                  Error: wrong configuration markup:<br/>
                  <pre>{config_string}</>
                </>
              )
  | {some=config} ->
    show_slideshow(config)

dispatch(uri : Uri.relative) =
  match uri with
  | {path=[] query=[] ...} -> go(default_config())
  | {path=[] query=[("images", url)] ...} ->
    (match Uri.of_string(url)
    | {none} ->
        show_error(<>Error: wrong configuration URI: {url}</>)
    | {some=config_uri} ->
        match WebClient.Get.try_get(config_uri)
        | {failure=_} ->
            show_error(<>Error: problems fetching configuration from {url}</>)
        | {success=config} ->
            go(config.content)
    )
  | _ -> none

server = Server.full_dispatch(dispatch, identity)
server = Server.of_bundle([resources_css])
