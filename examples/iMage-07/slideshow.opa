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

  @private update_size_constraints(state) =
    wx = state.width
    wy = state.height
    do Dom.set_width(#{Id.slideshow}, wx)
    do Dom.set_width(#{Id.thumbs_out}, wx)
    do Dom.set_width(#{Id.photo}, wx)
    do Dom.set_height(#{Id.photo}, wy)
    do Dom.set_style(#{Id.img}, css {max-width: {wx}px; max-height: {wy}px})
    void

  @private update_window_size(state) =
    body = Dom.select_body()
    width_px = Dom.get_width(body)
    height_px = Dom.get_height(body) - 250
    aspect_x = 4
    aspect_y = 3
    (wx, wy) =
      if height_px * aspect_x > width_px * aspect_y then
        (width_px, width_px * aspect_y / aspect_x)
      else
        (height_px * aspect_x / aspect_y, height_px)
    {state with width=wx height=wy}

  @client @private slideshow_event(slideshow, state, msg) =
    match msg with
    | {ShowImg=img} ->
        do show_img(img)
        {unchanged}
    | {StartSlideshow} ->
        resize() = Session.send(slideshow, {WindowResized})
        _ = Dom.bind(Dom.select_window(), {resize}, (_ -> resize()))
        do resize()
        {unchanged}
    | {WindowResized} ->
        new_state = update_window_size(state)
        do update_size_constraints(new_state)
        {set=new_state}

  html(config) =
    slideshow_state = { img_no=List.length(config.images) width=0 height=0 }
    rec val slideshow = Session.make(slideshow_state, slideshow_event(slideshow, _, _))
    thumbs_css = css { width: {100 * slideshow_state.img_no}px }
    onready(_) =
      do Session.send(slideshow, {StartSlideshow})
      do Session.send(slideshow, {ShowImg=List.head(config.images)})
      void
    <div id=#{Id.main_title}>
      {config.title}
    </>
    <div id=#{Id.slideshow} onready={onready}>
      <div id=#{Id.photo} />
      <div id=#{Id.thumbs_out}>
        <div id=#{Id.thumbs_in} style={thumbs_css}>
          {List.map(show_thumb(slideshow, _), config.images)}
        </>
      </>
    </>

  markup_parser = SlideshowParser.markup_parser

}}
