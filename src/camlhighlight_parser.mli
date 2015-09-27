(********************************************************************************)
(*	Camlhighlight_parser.mli
	Copyright (c) 2010-2014 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(**	Facilities for converting source code into highlighted code.
*)

(********************************************************************************)
(**	{1 Exceptions}								*)
(********************************************************************************)

exception Cannot_initialize_hiliter
exception Cannot_initialize_mapper
exception Uninitialized
exception Unknown_language of Camlhighlight_core.lang
exception Hiliter_error of string


(********************************************************************************)
(**	{1 Public functions and values}						*)
(********************************************************************************)

(**	Sets the number of spaces per TAB character.
*)
val set_tabspaces: int -> unit

(**	Returns a list of all languages for which syntax highlighting is available.
	Each language is returned as a {!Camlhighlight_core.lang}, which can be
	given directly to function {!from_string}.
*)
val get_available_langs: unit -> Camlhighlight_core.lang list

(**	Returns a boolean indicating whether syntax highlighting is available for
	the given language.
*)
val is_available_lang: Camlhighlight_core.lang -> bool

(**	An invocation of [from_string ~lang source] will create a value of type
	{!Camlhighlight_core.t} containing the syntax-highlighted version of
	the source-code in string format passed in the [source] parameter.
	The optional parameter [lang] tells the highlighter which language
	conventions should be used for highlighting.  This parameter expects
	a value of type {!Camlhighlight_core.lang}; no actual highlighting
	will be done if it is not provided (in fact equivalent to specifying
	["txt"] as the language).
*)
val from_string: ?lang:Camlhighlight_core.lang -> string -> Camlhighlight_core.t

