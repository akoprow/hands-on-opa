import stdlib.web.template

resources_imgs = @static_resource_directory("resources/imgs")
resources_css = @static_resource_directory("resources/css")
footer = @static_content("footer.xmlt")

zoom_in(fn) =
  img = <img src={fn} />
  Dom.transform([#photo <- img])

show_img(fn) =
  <div class=container>
    <img onclick={_ -> zoom_in(fn)} src={fn} />
  </>

page() =
  footer =
    Template.parse(Template.default, footer())
    |> Template.to_xhtml(Template.default, _)
  img_list = Map.To.key_list(resources_imgs)
  thumbs_css = css { width: {100 * List.length(img_list)}px }
  <>
    <div id=#slideshow>
      <div id=#photo />
      <div id=#thumbs_out>
        <div id=#thumbs_in style={thumbs_css}>
          {List.map(show_img, img_list)}
        </>
      </>
    </>
    {footer}
  </>

server = Server.one_page_bundle("iMage: a magical image viewer!",
           [resources_imgs, resources_css], ["resources/css/css.css"], page)
