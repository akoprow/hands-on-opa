ws(p) = parser
| Rule.ws res=p Rule.ws -> res

calculator =
  rec term = parser
  | f={ws(Rule.float)} -> f
  | {ws(parser "(")} ~expr {ws(parser ")")} -> expr
  and factor = parser
  | ~term "*" ~factor -> term * factor
  | ~term "/" ~factor -> term / factor
  | ~term -> term
  and expr = parser
  | ~factor "+" ~expr -> factor + expr
  | ~factor "-" ~expr -> factor - expr
  | ~factor -> factor
  expr

calculate(_evt) =
  (answer, error) =
    match Parser.try_parse(calculator, Dom.get_value(#expr)) with
    | {some=result} -> (<>{result}</>, <></>)
    | {none} -> (<></>, <>Sorry, but I'm a simple calculator that only understands +, -, *, / and parentheses (...).</>)
  do Dom.transform([#answer <- answer])
  do Dom.transform([#error <- error])
  void

page() =
  <div id=#calc>
    <input id=#expr type=text onnewline={calculate} />
    <button id=#equals onclick={calculate}>=</button>
    <span id=#answer />
    <div id=#error />
  </>

server = Server.one_page_bundle("Calculator", [@static_resource_directory("resources")],
       ["resources/style.css"], page)
