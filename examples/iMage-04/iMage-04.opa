import stdlib.web.template
import mlstate.image.slideshow

resources_imgs = @static_resource_directory("resources/imgs")
resources_css = @static_resource_directory("resources/css")
footer = @static_content("footer.xmlt")

page() =
  footer =
    Template.parse(Template.default, footer())
    |> Template.to_xhtml(Template.default, _)
  <>
    {WSlideshow.html(resources_imgs)}
    {footer}
  </>

server = Server.one_page_bundle("iMage: a magical image viewer!",
           [resources_imgs, resources_css], ["resources/css/css.css"], page)
