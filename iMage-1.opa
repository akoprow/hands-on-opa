import stdlib.web.template

resources_imgs = @static_resource_directory("resources/imgs")
footer = @static_content("footer.xmlt")

show_img(fn) =
  <img src={fn} />

page() =
  footer =
    Template.parse(Template.default, footer())
    |> Template.to_xhtml(Template.default, _)
  img_list = Map.To.key_list(resources_imgs)
  <>
    {List.map(show_img, img_list)}
    {footer}
  </>

server = Server.one_page_bundle("iMage: a magical image viewer!",
           [resources_imgs], [], page)
