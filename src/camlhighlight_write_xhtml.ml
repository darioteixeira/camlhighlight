(********************************************************************************)
(*	Camlhighlight_write_xhtml.ml
	Copyright (c) 2010 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

open ExtList
open XHTML.M
open Camlhighlight_core


(********************************************************************************)
(**	{1 Public functions and values}						*)
(********************************************************************************)

(**	This function converts a value of type {!Camlhighlight_core.t} containing
	a syntax-highlighted document into its Ocsigen's [XHTML.M] representation.
	The optional parameter [class_prefix] indicates the prefix for the class
	names of all XHTML elements produced, while [extra_classes] can be used
	to provide additional class names for the main container.  Also optional
	are the boolean parameters [dummy_lines], and [linenums].  They indicate
	whether the generated XHTML should include dummy lines at the beginning
	and end, and line numbers for the code, respectively.
*)
let write ?(class_prefix = "hl_") ?(extra_classes = []) ?(dummy_lines = true) ?(linenums = false) code =
	let make_class ?(extra_classes = []) names = a_class (extra_classes @ (List.map (fun x -> class_prefix ^ x) names)) in
	let normal_line content = [pcdata "\n"; XHTML.M.code ~a:[make_class ["line"]] content] in
	let dummy = if dummy_lines then [pcdata "\n"; XHTML.M.code ~a:[make_class ["line"; "dummy"]] []] else [] in
	let elem_to_xhtml = function
		| ("normal", str) -> XHTML.M.pcdata str
		| (special, str)  -> XHTML.M.span ~a:[make_class [special]] [XHTML.M.pcdata str] in
	let convert_nums () =
		let code_len = List.length code in
		let width = String.length (string_of_int code_len) in
		let numline_to_xhtml num = normal_line [XHTML.M.pcdata (Printf.sprintf "%0*d" width num)]
		in XHTML.M.pre ~a:[make_class ["nums"]] (dummy @ (List.flatten (List.map numline_to_xhtml (List.init code_len (fun x -> x+1)))) @ dummy)
	and convert_code () =
		let codeline_to_xhtml line = normal_line (List.map elem_to_xhtml line)
		in XHTML.M.pre ~a:[make_class ["code"]] (dummy @ (List.flatten (List.map codeline_to_xhtml code)) @ dummy)
	in XHTML.M.div ~a:[make_class ~extra_classes ["main"]]
		(match linenums with
			| true	-> [convert_nums (); convert_code ()]
			| false -> [convert_code ()])


