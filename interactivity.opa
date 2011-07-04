Id = {{
  time="time"
  counter="counter"
}}

show_time() = Dom.transform([#{Id.time} <- <>{Date.to_string(Date.now())}</>])

db /counter : int
clicked(_) =
  do /counter <- /counter + 1
  Dom.transform([#{Id.counter} <- <>I've been clicked {/counter} time(s).</>])

page() =
  <span onready={_ -> Scheduler.timer(1000, show_time)}>
    <span id={Id.time}> </>
    <button onclick={clicked}>Click me!</>
    <span id={Id.counter} />
  </>

server = one_page_server("What's the time?", page)
