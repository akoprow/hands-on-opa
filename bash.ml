##register execute: string -> void
let execute cmd =
  match Unix.system cmd with
  | Unix.WEXITED 0 -> ()
  | _ -> failwith (Printf.sprintf "Executing command %s failed" cmd)
