(********************************************************************************)
(*	test.ml
	Copyright (c) 2009 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(*	Basic demo of Camlhighlight library.
*)

let () =
	let ch = open_in "test.ml" in
	let src = Std.input_all ch in
	let () = close_in ch in
	let hilite = Camlhighlight_parser.from_string "ml" src in
	let str = Sexplib.Sexp.to_string_mach (Camlhighlight_core.sexp_of_t hilite)
	in print_endline str

