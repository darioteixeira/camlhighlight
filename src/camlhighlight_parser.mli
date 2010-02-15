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
(**	{1 Public functions and values}						*)
(********************************************************************************)

val from_string: ?lang:Camlhighlight_core.lang_t -> string -> Camlhighlight_core.t

