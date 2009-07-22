(********************************************************************************)
(*	test.ml
	Copyright (c) 2009 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(*	Basic demo of Camlhighlight library.
*)

open Camlhighlight_lowlevel


let () =
	let ch = open_in "test.ml" in
	let src = Std.input_all ch in
	let () = close_in ch in
	let basedir = "/home/dario/.local/share/highlight" in
	let style = basedir ^ "/themes/kwrite.style" in
	let lang = basedir ^ "/langDefs/ml.lang" in
	let gen = Camlhighlight_lowlevel.create () in
	let _ = Camlhighlight_lowlevel.init_theme gen style in
	let _ = Camlhighlight_lowlevel.load_language gen lang in
	let () = Camlhighlight_lowlevel.set_fragment_code gen true in
	let () = Camlhighlight_lowlevel.set_preformatting gen Wrap_disabled 0 8 in
	let res = Camlhighlight_lowlevel.generate_string gen src
	in print_endline res

