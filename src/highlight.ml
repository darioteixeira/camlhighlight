(********************************************************************************)
(*	Implementation file for Highlight.

	Copyright (c) 2008 Dario Teixeira (dario.teixeira@yahoo.com)

	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(**	The [Highlight] module provides facilities for parsing and pretty-printing
	source code.
*)

TYPE_CONV_PATH "Highlight"

open ExtList
open ExtString
open XHTML.M
open Pxp_core_types
open Pxp_document
open Pxp_yacc


(********************************************************************************)
(**	{2 Aggregator submodule}						*)
(********************************************************************************)

(**	This module provides a set of utility functions that allow us to transform
	a stream of tokens from the PXP parser into a {!Highlight.t} value.
*)
module Aggregator:
sig
	type 'a t

	val create : unit -> 'a t
	val add : 'a t -> 'a -> unit
	val newline : 'a t -> unit
	val to_list_list : 'a t -> 'a list list
end =
struct
	type 'a t =
		{
		history: 'a DynArray.t DynArray.t;
		accum: 'a DynArray.t;
		}

	let create () =
		let history = DynArray.create ()
		and accum = DynArray.create ()
		in {history = history; accum = accum}

	let add agg el =
		DynArray.add agg.accum el

	let newline agg =
		DynArray.add agg.history (DynArray.copy agg.accum);
		DynArray.clear agg.accum

	let trim arr =
		try
			while (DynArray.empty (DynArray.get arr 0)) do DynArray.delete arr 0 done;
			while (DynArray.empty (DynArray.last arr)) do DynArray.delete_last arr done
		with
			DynArray.Invalid_arg _ -> ()

	let to_list_list agg =
	let clone = DynArray.copy agg.history
	in	DynArray.add clone agg.accum;
		trim clone;
		DynArray.to_list (DynArray.map DynArray.to_list clone)
end


(********************************************************************************)
(**	{2 Public types}							*)
(********************************************************************************)

(**	The various supported languages.
*)
type lang_t =
	| Lang_c
	| Lang_ocaml
	with sexp


(**	The various kinds of syntactically meaningful tokens recognised
	by the highlighter.
*)
type special_t =
	| Num		(** Number *)
	| Esc		(** Escaped character *)
	| Str		(** String *)
	| Dstr		(** String directive *)
	| Slc		(** Single line comment *)
	| Com		(** Regular comment *)
	| Dir		(** Compiler directive *)
	| Sym		(** Symbol *)
	| Kwa		(** Keyword class A *)
	| Kwb		(** Keyword class B *)
	| Kwc		(** Keyword class C *)
	| Kwd		(** Keyword class D *)
	with sexp


(**	Any individual element in the source code is either a "boring" value
	using the [Default] colour, or it's a [Special] value that should be
	highlight in a different colour.
*)
type elem_t =
	| Default of string
	| Special of special_t * string
	with sexp


(**	A line is composed of a list of {!elem_t}.
*)
type line_t = elem_t list with sexp


(**	The value of highlighted source-code samples.  It's a tuple consisting
	of the sample's language represented as [lang_t option], and a list of
	the sample's lines.
*)
type t = lang_t option * line_t list with sexp


(********************************************************************************)
(**	{2 Private functions}							*)
(********************************************************************************)

let string_of_lang = function
	| Lang_c	-> "c"
	| Lang_ocaml	-> "ml"


let string_of_maybe_lang = function
	| Some lang	-> string_of_lang lang
	| None		-> "dummy"


let special_of_string = function
	| "hl num"	-> Num
	| "hl esc"	-> Esc
	| "hl str"	-> Str
	| "hl dstr"	-> Dstr
	| "hl slc"	-> Slc
	| "hl com"	-> Com
	| "hl dir"	-> Dir
	| "hl sym"	-> Sym
	| "hl kwa"	-> Kwa
	| "hl kwb"	-> Kwb
	| "hl kwc"	-> Kwc
	| "hl kwd"	-> Kwd
	| _		-> assert false


let string_of_special = function
	| Num		-> "num"
	| Esc		-> "esc"
	| Str		-> "str"
	| Dstr		-> "dstr"
	| Slc		-> "slc"
	| Com		-> "com"
	| Dir		-> "dir"
	| Sym		-> "sym"
	| Kwa		-> "kwa"
	| Kwb		-> "kwb"
	| Kwc		-> "kwc"
	| Kwd		-> "kwd"


let special_of_attribute = function
	| Value x	-> special_of_string x
	| _		-> assert false


let convert_node agg node = match node#node_type with
	| T_element _ ->
		Aggregator.add agg (Special (special_of_attribute (node#attribute "class"), node#data))
	| T_data ->
		let lines = String.nsplit node#data "\n" in
		let adder = function
			| ""	-> ()
			| x	-> Aggregator.add agg (Default x)
		in (match lines with
			| hd :: tl      -> adder hd; List.iter (fun el -> Aggregator.newline agg; adder el) tl
			| []            -> ())
	| _ ->
		assert false


let convert_document root = match root#node_type with
	| T_element _ ->
		let nodes = root#sub_nodes in
		let agg = Aggregator.create () 
		in	List.iter (convert_node agg) nodes;
			Aggregator.to_list_list agg
	| _ ->
		assert false


let parse_highlight html_str =
	let config =
		{
		default_config with
		encoding = `Enc_utf8;
		drop_ignorable_whitespace = false;
		}
	in try
		parse_wfdocument_entity config (from_string html_str) default_spec
	with
		exc -> print_endline (Pxp_types.string_of_exn exc);
		raise exc


let invoke_highlighter syntax source =
	let exec = "/usr/bin/env" in
	let params = ["highlight"; "--xhtml"; "--force"; "--fragment"; "--syntax " ^ syntax; "--replace-tabs=8"] in
	let cmdline = String.concat " " (exec :: params) in
	let (in_ch, out_ch) = Unix.open_process cmdline in
	let () =
		output_string out_ch source;
		flush out_ch;
		close_out out_ch in
	let highlight = Std.input_all in_ch in
	let _ = Unix.close_process (in_ch, out_ch)
	in highlight


(********************************************************************************)
(**	{2 Public functions}							*)
(********************************************************************************)

(**	This utility function returns the {!lang_t} value that corresponds
	to the provided [string].  It raises {!Unknown_language} should the
	language be unknown.
*)
let lang_of_string = function
	| "c"		-> Lang_c
	| "ocaml"	-> Lang_ocaml
	| x		-> invalid_arg x


(**	An invocation of [from_string lang source] will create a value of type {!t}
	containing the syntax-highlighted version of the source-code in [string]
	format passed in the [source] parameter.  The [lang] parameter tells the
	highlighter which conventions are used for highlighting.  It is an optional
	value of type {!lang_t}.  If [None], no proper syntax-highlighting will
	be done (the returned value will contain only [Default] lines).
*)
let from_string maybe_lang source =
	let syntax = string_of_maybe_lang maybe_lang in
	let html_raw = invoke_highlighter syntax source in
	let html_proper = "<source>" ^ html_raw ^ "</source>" in
	let doc = parse_highlight html_proper
	in (maybe_lang, convert_document doc#root)


(**	This converts a value of type {!t} containing a syntax-highlighted
	document into its Ocsigen's [XHTML.M] representation.  The optional
	parameter [class_prefix] indicates the prefix for the class names
	of all XHTML elements produced, while [extra_classes] can be used
	to provide additional class names for the main container.  The,
	also optional, parameters [linenums] and [zebra] are both booleans
	indicating whether the generated XHTML should include line numbers
	for the code and/or use fancy zebra stripes to distinguish each line.
*)
let to_xhtml ?(class_prefix = "hl_") ?(extra_classes = []) ?(dummy_lines = true) ?(linenums = false) ?(zebra = false) (_, code) =
	let code_len = lazy (List.length code) in
	let suffix = [XHTML.M.space (); XHTML.M.pcdata "\n"] in
	let make_class ?(extra_classes = []) names =
		a_class (extra_classes @ (List.map (fun x -> class_prefix ^ x) names)) in
	let elem_to_xhtml = function
		| Default s		-> XHTML.M.pcdata s
		| Special (special, s)	-> XHTML.M.span ~a:[make_class [string_of_special special]] [XHTML.M.pcdata s] in
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
		(match linenums with
			| true	-> [convert_nums (); convert_code ()]
			| false -> [convert_code ()])

