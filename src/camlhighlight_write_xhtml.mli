(********************************************************************************)
(*	Camlhighlight_write_xhtml.mli
	Copyright (c) 2010 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(**	Facilities for converting highlighted code into Ocsigen's [XHTML.M]
	representation.
*)


(********************************************************************************)
(**	{2 Public functions}							*)
(********************************************************************************)

val write:
	?class_prefix:string ->
	?extra_classes:XHTML.M.nmtoken list ->
	?dummy_lines:bool ->
	?linenums:bool ->
	Camlhighlight_core.t ->
	[> `Div ] XHTML.M.elt

