import stdlib.web.template

footer = @static_content("footer.xmlt")

page() =
  Template.parse(Template.default, footer())
  |> Template.to_xhtml(Template.default, _)

server = Server.one_page_server("iMage: a magical image viewer!", page)
