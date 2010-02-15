(********************************************************************************)
(*	Camlhighlight_parser.ml
	Copyright (c) 2010 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

open ExtString


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

exception Unknown_lang of Camlhighlight_core.lang_t


(********************************************************************************)
(**	{1 Module initialisation}						*)
(********************************************************************************)

let () =
	init ();
	Callback.register_exception "invalid_lang" (Unknown_lang "")


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
	let lines = String.nsplit (highlight lang source) "\n" in
	let conv line = Camlhighlight_core.line_t_of_sexp (Sexplib.Sexp.of_string ("(" ^ line ^ ")"))
	in List.map conv lines

