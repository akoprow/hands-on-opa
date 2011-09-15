package hands-on-opa.units.ui

type Ui.value_holder('a) =
  { get : -> 'a
  ; set : 'a -> void
  }

type Ui.editable('a) =
  { xhtml : { onchange : -> void } -> xhtml
  ; value : Ui.value_holder('a)
  }

Ui = {{
  select(options : list('a)) : Ui.editable('a) =
    id = Dom.fresh_id()
    {
      xhtml(~{onchange}) =
        <select id={id} onchange={_ -> onchange()}>
          {List.mapi(i, x -> <option value="{i}">{x}</option>, options)}
        </select>
      value =
      {
        get() = List.unsafe_get(String.to_int(Dom.get_value(#{id})), options)
        set(v) = Dom.set_value(#{id}, Int.to_string(List.index(v, options) ? 0))
      }
    }

  input(print : 'a -> string, parse : string -> 'a) : Ui.editable('a) =
    id = Dom.fresh_id()
    {
      xhtml(~{onchange}) =
        <input id={id} type="text" onkeyup={_ -> onchange()} />
      value =
      {
        get() = parse(Dom.get_value(#{id}))
        set(v) = Dom.set_value(#{id}, print(v))
      }
    }

}}
