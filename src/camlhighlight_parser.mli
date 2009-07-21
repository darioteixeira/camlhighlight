(********************************************************************************)
(*	Camlhighlight_parser.mli
	Copyright (c) 2009 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(********************************************************************************)
(**	{2 Exceptions}								*)
(********************************************************************************)

exception Not_initialized
exception Failed_loading_theme
exception Failed_loading_language
exception Failed_loading_language_regex


(********************************************************************************)
(**	{2 Public functions}							*)
(********************************************************************************)

val init: ?basedir:string -> unit -> unit
val from_string: Camlhighlight_core.lang_t -> string -> Camlhighlight_core.t

