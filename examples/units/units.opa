package hands-on-opa.units.main
import hands-on-opa.units.ui

type Length.unit = {m} / {in}
type Length.length = { value : float; unit : Length.unit }
type Length.conversion = { from : Length.unit; to : Length.unit }

units : list(Length.unit) = [{m}, {in}]

@xmlizer(Length.unit) _ =
  | {m} -> <>m</>
  | {in} -> <>in</>

@xmlizer(Length.length) _ =
  | ~{value unit} -> <>{Float.to_formatted_string(false, some(3), value)} {unit}</>

Length = {{
  @private ratio(~{from to} : Length.conversion) : float =
    if from == to then 1.
    else match ~{from to} with
      | {from={in} to={m}} -> 0.0254
      | _ -> 1. / ratio({from=to to=from})

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
        display.set(<>{ Length.convert(l, u) }</>)
    <>
      <h1>A simple unit converter</h1>
      Convert { length.xhtml } to {unit.xhtml}
      <button onclick={_ -> convert() }>convert</button>
      { display.xhtml }
    </>

  server_interface() =
    <div onready={_ -> Dom.transform([#Body <- interface()])} />
}}

server = Server.one_page_server(" -- A simple length converter -- ", MainUi.server_interface)
