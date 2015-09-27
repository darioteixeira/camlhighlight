(********************************************************************************)
(*  test.ml
    Copyright (c) 2010 Dario Teixeira (dario.teixeira@yahoo.com)
    This software is distributed under the terms of the GNU GPL version 2.
    See LICENSE file for full license text.
*)
(********************************************************************************)

(*  Basic demo of Camlhighlight library.
*)

let availability () =
    let langs = Camlhighlight_parser.get_available_langs () in
    let check_lang lang = Printf.printf "Is '%s' available? -> %B\n" lang (Camlhighlight_parser.is_available_lang lang)
    in List.iter check_lang langs

let highlight () =
    let ch = open_in "test_parser.ml" in
    let src = Std.input_all ch in
    let () = close_in ch in
    let hilite = Camlhighlight_parser.from_string ~lang:"caml" src in
    let str = Sexplib.Sexp.to_string_mach (Camlhighlight_core.sexp_of_t hilite)
    in print_endline str

let () =
    availability ();
    highlight ()

