package mlstate.image.slideshow

type WSlideshow.image =
  { src : Uri.uri
  ; link : option(Uri.uri)
  ; author : option(xhtml)
  ; title : option(xhtml)
  ; description : option(xhtml)
  }

type WSlideshow.config =
  { title : xhtml
  ; images : list(WSlideshow.image)
  }

WSlideshow =
{{

  @private Id =
  {{
    main_title = "main_title"
    slideshow = "slideshow"
    img = "img"
    img_area = "img_area"
    img_overlays = "img_overlays"
    img_captions_top = "img_captions_top"
    img_captions_bottom = "img_captions_bottom"
    img_title = "img_title"
    img_author = "img_author"
    img_description = "img_description"
    photo = "photo"
    thumbs_out = "thumbs_out"
    thumbs_in = "thumbs_in"
  }}

  @private zoom_in(image) =
    photo =
      img = <img id=#{Id.img} src={Uri.to_string(image.src)} />
      match image.link with
      | {some=uri} -> <a href={uri}>{img}</a>
      | _ -> img
    photo_container =
      <div id=#{Id.img_area}>
        {photo}
        <div id={Id.img_overlays}>
          <div id=#{Id.img_captions_top}>
            <div id=#{Id.img_title}>{image.title ? <></>}</>
            <div id=#{Id.img_author}>{image.author ? <></>}</>
          </>
          <div id=#{Id.img_captions_bottom}>
            <div id=#{Id.img_description}>{image.description}</>
          </>
        </>
      </>
    Dom.transform([#{Id.photo} <- photo_container])

  @private show_img(image) =
    <div class=container>
      <img onclick={_ -> zoom_in(image)} src={Uri.to_string(image.src)} />
    </>

  html(config) =
    thumbs_css = css { width: {100 * List.length(config.images)}px }
    <div id=#{Id.main_title}>
      {config.title}
    </>
    <div id=#{Id.slideshow}
      onready={_ -> zoom_in(List.head(config.images))}>
      <div id=#{Id.photo} />
      <div id=#{Id.thumbs_out}>
        <div id=#{Id.thumbs_in} style={thumbs_css}>
          {List.map(show_img, config.images)}
        </>
      </>
    </>

  @private ws = parser [ ]* -> void

  @private eol = parser [\n] -> void

  @private separator = parser "####" [#]* ws eol -> void

  @private entry(label, content) =
    parser "{label}:" ws res=content -> res

  @private linkifier =
    link = parser
      "[" name=((!"]" .)*) "](" link=UriParser.uri ")" -> <a href={link}>{name}</>
    msg_segment = parser
    | ~link -> link
    | s=((!link .)+) -> <>{s}</>
    parser ls=msg_segment* -> <>{ls}</>

  @private full_line_parser =
    parser txt=((!eol .)*) eol ->
      Parser.try_parse(linkifier, "{txt}") ? <></>

  @private multi_line_parser =
    parser lines=(!separator l=full_line_parser -> l)+ ->
      XmlConvert.of_list_using(<></>, <br/>, <br/>, lines)

  markup_parser : Parser.general_parser(WSlideshow.config) =
    src = entry("Image", Uri.uri_parser)
    link = entry("Link", Uri.uri_parser)
    title  = entry("Title", full_line_parser)
    author = entry("Author", full_line_parser)
    image = parser ~src ~link? ~title? ~author? eol? description=multi_line_parser? ->
      ~{src link author title description} : WSlideshow.image
    images = Rule.parse_list_sep(true, image, separator)
    parser separator title=multi_line_parser ~images separator -> ~{title images}

}}
