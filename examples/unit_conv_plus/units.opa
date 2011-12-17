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

type LengthUi.editable = Ui.editable(Length.length)

LengthUi = {{
  control(params) : LengthUi.editable =
    float_printer =
    | {none} -> ""
    | {some=f} ->Float.to_formatted_string(false, some(3), f)
    unit = Ui.select(units)
    unit_value = Ui.input(params, float_printer, Parser.float)
    {
      xhtml(onchange) =
        <span>{unit_value.xhtml(onchange)}{unit.xhtml(onchange)}</span>
      value =
      {
        get() =
          { value = unit_value.value.get() ? 0.
          ; unit = unit.value.get()
          }
        set(v) =
          do unit.value.set(v.unit)
          do unit_value.value.set(some(v.value))
          void
      }
    }

  convert(from : LengthUi.editable, to : LengthUi.editable) =
    ->
      res_unit = to.value.get().unit
      res_value = Length.convert(from.value.get(), res_unit)
      to.value.set(res_value)

}}

MainUi = {{
  interface() =
    length1 = LengthUi.control({readonly=false})
    length2 = LengthUi.control({readonly=true})
    change = LengthUi.convert(length1, length2)
    <div class="container">
      <h1>Length converter demo</>
      {length1.xhtml({onchange = change})} = {length2.xhtml({onchange = change})}
    </>

  server_interface() =
    <div onready={_ -> Dom.transform([#Body <- interface()])} />
}}

server = Server.one_page_bundle("A simple length converter", [@static_resource_directory("resources")],
       ["resources/style.css"], MainUi.server_interface)
