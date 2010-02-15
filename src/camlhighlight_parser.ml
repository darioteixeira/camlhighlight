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

external get_mapping: string -> string = "get_mapping"
external highlight: string -> string -> string = "highlight"


(********************************************************************************)
(**	{1 Public values and functions}						*)
(********************************************************************************)

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
	let langdef = get_mapping lang in
	let lines = String.nsplit (highlight source langdef) "\n" in
	let conv line = Camlhighlight_core.line_t_of_sexp (Sexplib.Sexp.of_string ("(" ^ line ^ ")"))
	in List.map conv lines

