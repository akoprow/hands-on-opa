import hands-on-opa.fragment

show_time(t) = <>{Date.to_string(t)}</>

on_msg(_state, {update=date}) =
  {re_render=some(show_time(date)) change_state=none}

page() =
  (timer_xhtml, timer) = CFragment.create(void, show_time(Date.now()), on_msg)
  update_timer() = CFragment.notify(timer, {update=Date.now()})
  do Scheduler.timer(1000, update_timer)
  timer_xhtml

server = one_page_server("What's the time?", page)
