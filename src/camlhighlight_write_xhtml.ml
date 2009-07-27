(********************************************************************************)
(*	Camlhighlight_write_xhtml.ml
	Copyright (c) 2009 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

open ExtList
open XHTML.M
open Camlhighlight_core


(********************************************************************************)
(**	{2 Public functions}							*)
(********************************************************************************)

(**	This function converts a value of type {!Camlhighlight_core.t} containing
	a syntax-highlighted document into its Ocsigen's [XHTML.M] representation.
	The optional parameter [class_prefix] indicates the prefix for the class
	names of all XHTML elements produced, while [extra_classes] can be used
	to provide additional class names for the main container.  Also optional
	are the boolean parameters [dummy_lines], [linenums], and [zebra].  They
	indicate whether the generated XHTML should include dummy lines at the
	beginning and end, line numbers for the code, and use fancy zebra stripes
	to distinguish each line, respectively.
*)
let write ?(class_prefix = "hl_") ?(extra_classes = []) ?(dummy_lines = true) ?(linenums = false) ?(zebra = false) code =
	let code_len = lazy (List.length code) in
	let suffix = [XHTML.M.space (); XHTML.M.pcdata "\n"] in
	let make_class ?(extra_classes = []) names =
		a_class (extra_classes @ (List.map (fun x -> class_prefix ^ x) names)) in
	let elem_to_xhtml = function
		| Default s		-> XHTML.M.pcdata s
		| Special (special, s)	-> XHTML.M.span ~a:[make_class [special]] [XHTML.M.pcdata s] in
	let line_class where =
		let (dumbness, num) = match where with
			| `Before	-> (["dummy"], 0)
			| `After	-> (["dummy"], (Lazy.force code_len) + 1)
			| `Main n	-> ([], n) in
		let parity = match (zebra, num mod 2 == 0) with
			| (true, true)	-> "even"
			| (true, false)	-> "odd"
			| (false, _)	-> "line"
		in make_class (parity :: dumbness) in
	let convert_nums () =
		let width = String.length (string_of_int (Lazy.force code_len)) in
		let numline_to_xhtml num =
			XHTML.M.span ~a:[line_class (`Main num)] [XHTML.M.pcdata (Printf.sprintf "%0*d\n" width num)] in
		let before = if dummy_lines then [XHTML.M.span ~a:[line_class `Before] suffix] else [] in
		let after = if dummy_lines then [XHTML.M.span ~a:[line_class `After] suffix] else []
		in XHTML.M.pre ~a:[make_class ["nums"]] (before @ (List.map numline_to_xhtml (List.init (Lazy.force code_len) (fun x -> x+1))) @ after)
	and convert_code () =
		let codeline_to_xhtml num line =
			XHTML.M.span ~a:[line_class (`Main (num+1))] ((List.map elem_to_xhtml line) @ suffix) in
		let before = if dummy_lines then [XHTML.M.span ~a:[line_class `Before] suffix] else [] in
		let after = if dummy_lines then [XHTML.M.span ~a:[line_class `After] suffix] else []
		in XHTML.M.pre ~a:[make_class ["code"]] (before @ (List.mapi codeline_to_xhtml code) @ after)
	in XHTML.M.div ~a:[make_class ~extra_classes ["main"]]
		[
		XHTML.M.div
			(match linenums with
				| true	-> [convert_nums (); convert_code ()]
				| false -> [convert_code ()])
		]


