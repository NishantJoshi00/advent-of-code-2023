let rec interact fn =
    try
      let input = read_line () in
          (input |> fn) :: interact fn
    with End_of_file -> []

let sanatize input =
    String.trim input
    |> String.split_on_char ' '
    |> List.map int_of_string

(* let rec print_list list = *)
(*     match list with *)
(*         | [] -> print_newline () *)
(*         | fst :: rst -> *)
(*             print_int fst; *)
(*             print_string " "; *)
(*             print_list rst *)

let rec window fn list =
    match list with
        | [] -> []
        | [ _ ] -> []
        | fst :: snd :: rst ->
            fn fst snd :: window fn (snd :: rst)

let diff_maker list = window (fun a b -> b - a) list

let rec dc ls =
    if List.fold_left (fun x y -> x && y == 0) true ls then
      0
    else
      (ls |> List.rev |> List.hd) + (ls |> diff_maker |> dc)

let () =
    interact (fun x -> dc @@ sanatize @@ x)
    |> List.fold_left ( + ) 0
    |> print_int |> ignore
