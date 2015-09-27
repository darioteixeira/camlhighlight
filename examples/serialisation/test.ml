let () =
    let ch = open_in "test.ml" in
    let str = BatPervasives.input_all ch in
    let () = close_in ch in
    let () = Camlhighlight_parser.set_tabspaces 8 in
    Camlhighlight_parser.from_string ~lang:"caml" str |>
    Camlhighlight_core.sexp_of_t |>
    Sexplib.Sexp.to_string_hum |>
    print_string

