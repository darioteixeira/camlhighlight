(********************************************************************************)
(*  camlhighlight_write_xhtml_duce.mli
  Copyright (c) 2010 Alexander Markov <apsheronets@gmail.com>
  This software is distributed under the terms of the GNU GPL version 2.
  See LICENSE file for full license text.
*)
(********************************************************************************)

(**	Facilities for converting highlighted code into TyXML's [XHTML_types_duce]
	representation.
*)


(********************************************************************************)
(**	{2 Public functions}							*)
(********************************************************************************)

(**	This function converts a value of type {!Camlhighlight_core.t} containing
	a syntax-highlighted document into its TyXML's [XHTML_types_duce] representation.
	The optional parameter [class_prefix] indicates the prefix for the class
	names of all XHTML elements produced, while [extra_classes] can be used
	to provide additional class names for the main container.  Also optional
	are the boolean parameters [dummy_lines], and [linenums].  They indicate
	whether the generated XHTML should include dummy lines at the beginning
	and end, and line numbers for the code, respectively.
*)
val write:
	?class_prefix:string ->
	?extra_classes:string list ->
	?dummy_lines:bool ->
	?linenums:bool ->
	Camlhighlight_core.t ->
	XHTML_types_duce._div

