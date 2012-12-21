(********************************************************************************)
(*	Camlhighlight_write_html5.mli
	Copyright (c) 2010 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(**	Facilities for converting highlighted code into Eliom's [Html5.F]
	representation.
*)

open Eliom_content


(********************************************************************************)
(**	{2 Public functions}							*)
(********************************************************************************)

val write:
	?class_prefix:string ->
	?extra_classes:Html5_types.nmtoken list ->
	?dummy_lines:bool ->
	?linenums:bool ->
	Camlhighlight_core.t ->
	[> `Div ] Html5.F.elt

