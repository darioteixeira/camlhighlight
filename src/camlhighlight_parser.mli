(********************************************************************************)
(*	Camlhighlight_parser.mli
	Copyright (c) 2010 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(**	Facilities for converting source code into highlighted code.
*)

(********************************************************************************)
(**	{2 Exceptions}								*)
(********************************************************************************)

exception Failed_loading_style of string
exception Failed_loading_language of string
exception Failed_loading_language_regex of string


(********************************************************************************)
(**	{2 Public functions}							*)
(********************************************************************************)

val get_available_langs: unit -> Camlhighlight_core.lang_t list
val is_available_lang: Camlhighlight_core.lang_t -> bool
val from_string: ?lang:Camlhighlight_core.lang_t -> string -> Camlhighlight_core.t

