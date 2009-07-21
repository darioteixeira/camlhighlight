(********************************************************************************)
(*	Camlhighlight_writer.mli
	Copyright (c) 2009 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)


(********************************************************************************)
(**	{2 Public functions}							*)
(********************************************************************************)

val write_xhtml:
	?class_prefix:string ->
	?extra_classes:XHTML.M.nmtoken list ->
	?dummy_lines:bool ->
	?linenums:bool ->
	?zebra:bool ->
	Camlhighlight_core.t ->
	[> `Div ] XHTML.M.elt

