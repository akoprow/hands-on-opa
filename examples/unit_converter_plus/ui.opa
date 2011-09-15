package hands-on-opa.units.ui

type Ui.editable('a) =
  { xhtml : xhtml
  ; get : -> 'a
  ; set : 'a -> void
  }

Ui = {{
  select(options : list('a)) : Ui.editable('a) =
    id = Dom.fresh_id()
    {
      xhtml =
        <select id={id}>
          {List.mapi(i, x -> <option value="{i}">{x}</option>, options)}
        </select>
      get() = List.unsafe_get(String.to_int(Dom.get_value(#{id})), options)
      set(v) = Dom.set_value(#{id}, Int.to_string(List.index(v, options) ? 0))
    }

  input(print : 'a -> string, parse : string -> 'a) : Ui.editable('a) =
    id = Dom.fresh_id()
    {
      xhtml = <input id={id} type="text"/>
      get() = parse(Dom.get_value(#{id}))
      set(v) = Dom.set_value(#{id}, print(v))
    }

}}
