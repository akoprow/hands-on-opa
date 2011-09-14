package hands-on-opa.units.ui

type Ui.getter('a) = { xhtml : xhtml; get : -> 'a }
type Ui.setter('a) = { xhtml : xhtml; set : 'a -> void }

Ui = {{
  select(options : list('a)) : Ui.getter('a) =
    id = Dom.fresh_id();
    get() = List.unsafe_get(String.to_int(Dom.get_value(#{id})), options) :'a ;
    {
      xhtml =
        <select id={id}>
          { List.mapi(i, x -> <option value="{i}">{x}</option>, options) }
        </select> ;
      get = get
    }

  input(parse : string -> 'a) : Ui.getter('a) =
    id = Dom.fresh_id();
    {
      xhtml = <input id={id} type="text"/>;
      get() = parse(Dom.get_value(#{id}));
    }

  display() : Ui.setter('a) =
    id = Dom.fresh_id();
    {
      xhtml = <span id={id} />;
      set(x) =
        do Dom.hide(#{id})
        do Dom.transform([#{id} <- x])
        _ = Dom.transition(#{id}, Dom.Effect.with_duration({slow}, Dom.Effect.show()))
        void;
    }
}}
