(********************************************************************************)
(*	Camlhighlight_parser.mli
	Copyright (c) 2009 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(********************************************************************************)
(**	{2 Public functions}							*)
(********************************************************************************)

val from_string: Camlhighlight_core.lang_t option -> string -> Camlhighlight_core.t
