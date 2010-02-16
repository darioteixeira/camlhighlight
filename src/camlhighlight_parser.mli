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
(**	{1 Exceptions}								*)
(********************************************************************************)

exception Unknown_language of Camlhighlight_core.lang_t


(********************************************************************************)
(**	{1 Public functions and values}						*)
(********************************************************************************)

val get_available_langs: unit -> Camlhighlight_core.lang_t list
val is_available_lang: Camlhighlight_core.lang_t -> bool
val from_string: ?lang:Camlhighlight_core.lang_t -> string -> Camlhighlight_core.t

