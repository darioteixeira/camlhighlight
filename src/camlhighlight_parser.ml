(********************************************************************************)
(*	Camlhighlight_parser.ml
	Copyright (c) 2009 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

open ExtList
open ExtString
open Pxp_types
open Pxp_document
open Camlhighlight_core


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
(**	{2 Private values and functions}					*)
(********************************************************************************)

let gen = Camlhighlight_lowlevel.create ()


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


let convert_node agg node = match node#node_type with
	| T_element _ ->
		Aggregator.add agg (Special (special_of_string (node#required_string_attribute "class"), node#data))
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
		Pxp_tree_parser.parse_wfdocument_entity config (Pxp_types.from_string html_str) Pxp_tree_parser.default_spec
	with
		exc -> print_endline (Pxp_types.string_of_exn exc);
		raise exc


(********************************************************************************)
(**	{2 Public functions}							*)
(********************************************************************************)

(**	An invocation of [from_string lang source] will create a value of type
	{!Camlhighlight.t} containing the syntax-highlighted version of the
	source-code in [string] format passed in the [source] parameter.  The
	[lang] parameter tells the highlighter which conventions are used for
	highlighting.  It is an optional value of type {!Camlhighlight.lang_t}.
	If [None], no proper syntax-highlighting will be done.
*)
let from_string maybe_lang source =
	let syntax = match maybe_lang with
		| Some lang	-> lang
		| None		-> "txt" in
	let _ = Camlhighlight_lowlevel.load_language gen syntax in
	let html_raw = Camlhighlight_lowlevel.generate_string gen source in
	let html_proper = "<source>" ^ html_raw ^ "</source>" in
	let doc = parse_highlight html_proper
	in (maybe_lang, convert_document doc#root)

