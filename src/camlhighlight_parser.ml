(********************************************************************************)
(*	Camlhighlight_parser.ml
	Copyright (c) 2010 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

open ExtString
open Sexplib


(********************************************************************************)
(**	{1 Private values and functions}					*)
(********************************************************************************)

external init: unit -> unit = "init"
external get_langs: unit -> string list = "get_langs"
external has_mapping: string -> bool = "has_mapping"
external highlight: string -> string -> string = "highlight"


(********************************************************************************)
(**	{1 Exceptions}								*)
(********************************************************************************)

exception Unknown_language of Camlhighlight_core.lang_t


(********************************************************************************)
(**	{1 Module initialisation}						*)
(********************************************************************************)

let () =
	init ();
	Callback.register_exception "unknown_language" (Unknown_language "")


(********************************************************************************)
(**	{1 Public values and functions}						*)
(********************************************************************************)

(**	Returns a list of all languages for which syntax highlighting is available.
	Each language is returned as a {!Camlhighlight_core.lang_t}, which can be
	given directly to function {!from_string}.
*)
let get_available_langs = get_langs


(**	Returns a boolean indicating whether syntax highlighting is available for
	the given language.
*)
let is_available_lang = has_mapping


(**	An invocation of [from_string ~lang source] will create a value of type
	{!Camlhighlight_core.t} containing the syntax-highlighted version of
	the source-code in string format passed in the [source] parameter.
	The optional parameter [lang] tells the highlighter which language
	conventions should be used for highlighting.  This parameter expects
	a value of type {!Camlhighlight_core.lang_t}; no actual highlighting
	will be done if it is not provided (in fact equivalent to specifying
	["txt"] as the language).
*)
let from_string ?(lang = "txt") source =
	let conv_style = function
		| "normal"		-> `Norm
		| "keyword"		-> `Kwd
		| "type"		-> `Type
		| "usertype"		-> `Utyp
		| "string"		-> `Str
		| "regexp"		-> `Rex
		| "specialchar"		-> `Sch
		| "comment"		-> `Com
		| "number"		-> `Num
		| "preproc"		-> `Prep
		| "symbol"		-> `Sym
		| "function"		-> `Fun
		| "cbracket"		-> `Cbrk
		| "predef_var"		-> `Pvar
		| "predef_func"		-> `Pfun
		| "classname"		-> `Clas
		| "linenum"		-> `Line
		| "url"			-> `Url
		| "date"		-> `Date
		| "time"		-> `Time
		| "file"		-> `File
		| "ip"			-> `Ip
		| "name"		-> `Name
		| "variable"		-> `Var
		| "italics"		-> `Ital
		| "bold"		-> `Bold
		| "underline"		-> `Undr
		| "fixed"		-> `Fixd
		| "argument"		-> `Arg
		| "optionalargument"	-> `Oarg
		| "math"		-> `Math
		| "bibtex"		-> `Bibx
		| "oldfile"		-> `Old
		| "newfile"		-> `New
		| "difflines"		-> `Diff
		| "selector"		-> `Sel
		| "property"		-> `Prop
		| "value"		-> `Val
		| "atom"		-> `Atom
		| "meta"		-> `Meta
		| _			-> `Norm in
	let elem_of_sexp = function
		| Sexp.List [Sexp.Atom s; Sexp.Atom c] -> (conv_style s, c)
		| _				       -> failwith "elem_of_sexp" in
	let line_of_sexp = function
		| Sexp.List l -> List.map elem_of_sexp l
		| _	      -> failwith "line_of_sexp" in
	let lines = String.nsplit (highlight lang source) "\n" in
	let conv line = line_of_sexp (Sexp.of_string ("(" ^ line ^ ")"))
	in List.map conv lines

