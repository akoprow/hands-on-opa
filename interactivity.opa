show_time() = Dom.transform([#time <- <>{Date.to_string(Date.now())}</>])

db /counter : int
clicked(_) =
  do /counter <- /counter + 1
  Dom.transform([#counter <- <>I've been clicked {/counter} time(s).</>])

page() =
  <span onready={_ -> Scheduler.timer(1000, show_time)}>
    <span id=#time> </>
    <button onclick={clicked}>Click me!</>
    <span id=#counter />
  </>

server = one_page_server("What's the time?", page)
