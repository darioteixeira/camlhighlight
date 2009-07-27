(********************************************************************************)
(*	Camlhighlight_parser.mli
	Copyright (c) 2009 Dario Teixeira (dario.teixeira@yahoo.com)
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

val from_string: Camlhighlight_core.lang_t option -> string -> Camlhighlight_core.t

