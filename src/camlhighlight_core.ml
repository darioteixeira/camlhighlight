(********************************************************************************)
(*	Camlhighlight_core.ml
	Copyright (c) 2010 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

TYPE_CONV_PATH "Camlhighlight_core"


(********************************************************************************)
(**	{1 Public types}							*)
(********************************************************************************)

(**	How the source language is specified.
*)
type lang_t = string with sexp


(**	An element is a pair consisting of a style and the contents.
*)
type elem_t = string * string with sexp


(**	A line is composed of a list of individual elements.
*)
type line_t = elem_t list with sexp


(**	The value of highlighted source-code samples.  It's just a list of lines.
*)
type t = line_t list with sexp

