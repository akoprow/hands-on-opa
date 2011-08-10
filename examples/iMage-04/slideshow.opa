package mlstate.image.slideshow

WSlideshow =
{{

  @private zoom_in(fn) =
    img = <img src={fn} />
    Dom.transform([#photo <- img])

  @private show_img(fn) =
    <div class=container>
      <img onclick={_ -> zoom_in(fn)} src={fn} />
    </>

  html(imgs) =
    img_list = Map.To.key_list(imgs)
    thumbs_css = css { width: {100 * List.length(img_list)}px }
    <div id=#slideshow>
      <div id=#photo />
      <div id=#thumbs_out>
        <div id=#thumbs_in style={thumbs_css}>
          {List.map(show_img, img_list)}
        </>
      </>
    </>

}}
