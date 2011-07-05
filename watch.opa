Id = {{ time = "time" }}

show_time() =
  time = Date.to_string(Date.now())
  Dom.transform([#{Id.time} <- <>{time}</>])

page() =
  <span id=#{Id.time} onready={_ -> Scheduler.timer(1000, show_time)} />

server = one_page_server("What's the time?", page)
