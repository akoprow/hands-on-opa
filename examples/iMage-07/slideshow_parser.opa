package mlstate.image.slideshow

@private SlideshowParser =
{{

  ws = parser [ ]* -> void

  eol = parser [\n] -> void

  separator = parser "####" "#"* ws eol -> void

  entry(label, content) =
    parser "{label}:" ws res=content -> res

  linkifier =
    link = parser
      "[" name=((!"]" .)*) "](" link=UriParser.uri ")" -> <a href={link}>{name}</>
    msg_segment = parser
    | ~link -> link
    | s=((!link .)+) -> <>{s}</>
    parser ls=msg_segment* -> <>{ls}</>

  full_line_parser =
    parser txt=((!eol .)*) eol ->
      Parser.try_parse(linkifier, "{txt}") ? <></>

  multi_line_parser =
    parser lines=(!separator l=full_line_parser -> l)+ ->
      XmlConvert.of_list_using(<></>, <br/>, <br/>, lines)

  markup_parser : Parser.general_parser(WSlideshow.config) =
    src = entry("Image", Uri.uri_parser)
    link = entry("Link", Uri.uri_parser)
    title  = entry("Title", full_line_parser)
    author = entry("Author", full_line_parser)
    image =
      parser ~src ~link? ~title? ~author? eol? description=multi_line_parser? ->
      ~{src link author title description} : WSlideshow.image
    images = Rule.parse_list_sep(true, image, separator)
    parser separator title=multi_line_parser ~images separator -> ~{title images}

}}
