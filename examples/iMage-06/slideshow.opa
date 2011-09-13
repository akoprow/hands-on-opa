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

  @private show_img(image) =
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

  @private show_thumb(slideshow, image) =
    <div class=container>
      <img onclick={_ -> Session.send(slideshow, {ShowImg=image})}
        src={Uri.to_string(image.src)} />
    </>

  @private slideshow_event(_state, msg) =
    match msg with
    | {ShowImg=img} ->
        do show_img(img)
        {unchanged}

  html(config) =
    slideshow = Session.make(void, slideshow_event)
    show_first_img = Session.send(slideshow, {ShowImg=List.head(config.images)})
    thumbs_css = css { width: {100 * List.length(config.images)}px }
    <div id=#{Id.main_title}>
      {config.title}
    </>
    <div id=#{Id.slideshow} onready={_ -> show_first_img}>
      <div id=#{Id.photo} />
      <div id=#{Id.thumbs_out}>
        <div id=#{Id.thumbs_in} style={thumbs_css}>
          {List.map(show_thumb(slideshow, _), config.images)}
        </>
      </>
    </>

  markup_parser = SlideshowParser.markup_parser

}}
