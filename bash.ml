##register execute: string -> void
let execute cmd =
  Printf.eprintf "Executing: <%s>%!\n" cmd;
  match Unix.system cmd with
  | Unix.WEXITED 0 -> ()
  | _ -> failwith (Printf.sprintf "Executing command %s failed" cmd)

##register execute_parallel: string -> void
let execute_parallel cmd =
  Printf.eprintf "Executing: <%s>%!\n" cmd;
  let _in, _out = Unix.open_process cmd in
  ()
