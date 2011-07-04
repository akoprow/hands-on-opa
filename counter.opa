Id = {{
  counter="counter"
}}

db /counter : int
clicked(_) =
  do /counter <- /counter + 1
  Dom.transform([#{Id.counter} <- <>I've been clicked {/counter} time(s).</>])

page() =
  <button onclick={clicked}>Click me!</>
  <span id={Id.counter} />

server = one_page_server("Counter", page)
