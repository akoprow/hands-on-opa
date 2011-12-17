package hands-on-opa.units.main
import hands-on-opa.units.ui
import stdlib.themes.bootstrap

type Length.unit = {cm} / {m} / {ft} / {in}
type Length.length = { value : float; unit : Length.unit }
type Length.conversion = { from : Length.unit; to : Length.unit }

units : list(Length.unit) = [{cm}, {m}, {in}, {ft}]

@xmlizer(Length.unit) _ =
  | {cm} -> <>cm</>
  | {m} -> <>m</>
  | {ft} -> <>ft</>
  | {in} -> <>in</>

@xmlizer(Length.length) _ =
  | ~{value unit} -> <>{Float.to_formatted_string(false, some(3), value)} {unit}</>

Length = {{
  @private ratio(~{from to} : Length.conversion) : float =
    if from == to then 1.
    else match ~{from to} with
      | {~from to={m}} ->
          (match from with
          | {cm} -> 0.01
          | {m} -> 1.
          | {in} -> 0.0254
          | {ft} -> 0.3048
          )
      | {from={m} to=_} -> 1. / ratio({from=to to=from})
      | _ -> ratio({~from to={m}}) * ratio({from={m} ~to})

  convert(length : Length.length, unit : Length.unit) : Length.length =
    { value = length.value * ratio({from=length.unit; to=unit}); ~unit }
}}

LengthUi = {{
  input() : Ui.getter(option(Length.length)) =
    unit = Ui.select(units)
    value = Ui.input(Parser.float)
    {
      xhtml = <span>{value.xhtml}{unit.xhtml}</span>
      get() = Option.map(value -> { ~value; unit = unit.get() }, value.get())
    }
}}

MainUi = {{
  interface() =
    length = LengthUi.input()
    unit = Ui.select(units)
    display = Ui.display()
    convert() =
      match length.get() with
      | {none} ->
        display.set(<>invalid length</>)
      | {some = l} ->
        u = unit.get()
        display.set(<>{l} = { Length.convert(l, u) }</>)
    <div class="container">
      <h1>Length converter demo</>
      <p>
        Convert { length.xhtml } to {unit.xhtml}
        <button class="primary btn" onclick={_ -> convert() }>convert</button>
        { display.xhtml }
      </>
    </>

  server_interface() =
    <div onready={_ -> Dom.transform([#Body <- interface()])} />
}}

server = Server.one_page_bundle("A simple length converter", [@static_resource_directory("resources")],
       ["resources/style.css"], MainUi.server_interface)
