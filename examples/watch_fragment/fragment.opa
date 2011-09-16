package hands-on-opa.fragment

type CFragment.action('state) =
  { re_render : option(xhtml)
  ; change_state : option('state)
  }

@abstract type CFragment.fragment('msg) = channel('msg)

CFragment =
{{

  @private on_notification(id, handler, state, msg) =
    res = handler(state, msg)
    re_render(xhtml) = Dom.transform([#{id} <- xhtml])
    do Option.iter(re_render, res.re_render)
    match res.change_state with
    | {none} -> {unchanged}
    | {some=new_state} -> {set=new_state}

  create(init_state : 'state, init_xhtml : xhtml,
         handler : 'state, 'msg -> CFragment.action
        ) : (xhtml, CFragment.fragment('msg)) =
    id = Dom.fresh_id()
    xhtml = <span id={id}>{init_xhtml}</>
    session = Session.make(init_state, on_notification(id, handler, _, _))
    (xhtml, session)

  notify(fragment : CFragment.fragment('msg), msg : 'msg) : void =
    Session.send(fragment, msg)

}}
