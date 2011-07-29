Id = {{ time = "time" }}

page() =
  show_time() =
    time = Date.to_string(Date.now())
    Dom.transform([#{Id.time} <- <>{time}</>])
  <span onready={_ -> Scheduler.timer(1000, show_time)}>
    <span id=#{Id.time} />
  </>

server = one_page_server("What's the time?", page)
