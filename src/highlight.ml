(********************************************************************************)
(*	Implementation file for the Camlhighlight library.

	Copyright (c) 2008 Dario Teixeira (dario.teixeira@yahoo.com)

	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

open ExtList
open ExtString
open XHTML.M
open Pxp_core_types
open Pxp_document
open Pxp_yacc


(********************************************************************************)
(**	{2 Aggregator submodule}						*)
(********************************************************************************)

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

	let to_list_list agg =
	let clone = DynArray.copy agg.history
	in	if not (DynArray.empty agg.accum)
		then DynArray.add clone agg.accum;
		DynArray.to_list (DynArray.map DynArray.to_list clone)
end


(********************************************************************************)
(**	{2 Public types}							*)
(********************************************************************************)

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


type elem_t =
	| Default of string
	| Special of special_t * string


type line_t = elem_t list


type t = line_t list


(********************************************************************************)
(**	{2 Private functions}							*)
(********************************************************************************)

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

let class_of_special special = "hl_" ^ (string_of_special special)


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
	let params = ["highlight"; "--xhtml"; "--fragment"; "--syntax " ^ syntax; "--replace-tabs=8"] in
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

let from_string syntax source =
	let html_raw = invoke_highlighter syntax source in
	let html_proper = "<source>" ^ html_raw ^ "</source>" in
	let doc = parse_highlight html_proper in
	convert_document doc#root


let to_xhtml ?(linenums = false) ?(fancy = false) hilite =
	let elem_to_xhtml = function
		| Default s		-> XHTML.M.pcdata s
		| Special (special, s)	-> XHTML.M.span ~a:[a_class [class_of_special special]] [XHTML.M.pcdata s] in
	let line_class num = "hl_line" ^ (match (fancy, num mod 2 == 0) with
		| (true, true)	-> " hl_even"
		| (true, false)	-> " hl_odd"
		| (false, _)	-> "") in
	let make_nums () =
		let width = String.length (string_of_int (List.length hilite)) in
		let numline_to_xhtml num =
			XHTML.M.span ~a:[a_class [line_class num]] [XHTML.M.pcdata (Printf.sprintf "%0*d" width num)]
		in XHTML.M.pre ~a:[a_class ["hl_nums"]] (List.map numline_to_xhtml (List.init (List.length hilite) (fun x -> x+1)))
	and make_code () =
		let codeline_to_xhtml num line =
			XHTML.M.span ~a:[a_class [line_class (num+1)]] (List.append (List.map elem_to_xhtml line) [XHTML.M.space ()])
		in XHTML.M.pre ~a:[a_class ["hl_code"]] (List.mapi codeline_to_xhtml hilite)
	in XHTML.M.div ~a:[a_class ["hl_div"]]
		(match linenums with
			| true	-> [make_nums (); make_code ()]
			| false -> [make_code ()])
	

let output_highlight outf hilite =
	let sprint_elem = function
		| Default s		-> Printf.sprintf " «%s»" s
		| Special (special, s)	-> Printf.sprintf " $%s: «%s»" (string_of_special special) s in
	let print_line line =
		Printf.fprintf outf "#%s#\n" (List.fold_left (^) "" (List.map sprint_elem line))
	in List.iter print_line hilite

