(********************************************************************************)
(*	Camlhighlight_write_html5.ml
	Copyright (c) 2010 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

open Eliom_content
open Html5.F
open ExtList
open Camlhighlight_core


(********************************************************************************)
(**	{1 Public functions and values}						*)
(********************************************************************************)

(**	This function converts a value of type {!Camlhighlight_core.t} containing
	a syntax-highlighted document into its Eliom's [Html5.F] representation.
	The optional parameter [class_prefix] indicates the prefix for the class
	names of all HTML5 elements produced, while [extra_classes] can be used
	to provide additional class names for the main container.  Also optional
	are the boolean parameters [dummy_lines], and [linenums].  They indicate
	whether the generated HTML5 should include dummy lines at the beginning
	and end, and line numbers for the code, respectively.
*)
let write ?(class_prefix = "hl_") ?(extra_classes = []) ?(dummy_lines = true) ?(linenums = false) code =
	let make_class ?(extra_classes = []) names = a_class (extra_classes @ (List.map (fun x -> class_prefix ^ x) names)) in
	let normal_line content = [pcdata "\n"; Html5.F.code ~a:[make_class ["line"]] content] in
	let dummy = if dummy_lines then [pcdata "\n"; Html5.F.code ~a:[make_class ["line"; "dummy"]] []] else [] in
	let class_of_special special =
		Sexplib.Sexp.to_string_mach (Camlhighlight_core.sexp_of_special_style_t special) in
	let elem_to_xhtml = function
		| (#normal_style_t, str)	     -> Html5.F.pcdata str
		| (#special_style_t as special, str) -> Html5.F.span ~a:[make_class [class_of_special special]] [Html5.F.pcdata str] in
	let convert_nums () =
		let code_len = List.length code in
		let width = String.length (string_of_int code_len) in
		let numline_to_xhtml num = normal_line [Html5.F.pcdata (Printf.sprintf "%0*d" width num)]
		in Html5.F.pre ~a:[make_class ["nums"]] (dummy @ (List.flatten (List.map numline_to_xhtml (List.init code_len (fun x -> x+1)))) @ dummy)
	and convert_code () =
		let codeline_to_xhtml line = normal_line (List.map elem_to_xhtml line)
		in Html5.F.pre ~a:[make_class ["code"]] (dummy @ (List.flatten (List.map codeline_to_xhtml code)) @ dummy)
	in Html5.F.div ~a:[make_class ~extra_classes ["main"]]
		(match linenums with
			| true	-> [convert_nums (); convert_code ()]
			| false -> [convert_code ()])


