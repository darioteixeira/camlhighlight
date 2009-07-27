(********************************************************************************)
(*	Camlhighlight_core.mli
	Copyright (c) 2009 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(**	Definition of the basic types for the [Camlhighlight] library.
*)


(********************************************************************************)
(**	{2 Exceptions}								*)
(********************************************************************************)

exception Invalid_language of string


(********************************************************************************)
(**	{2 Public types}							*)
(********************************************************************************)

type lang_t with sexp

type elem_t =
	| Default of string
	| Special of string * string
	with sexp

type line_t = elem_t list with sexp

type t = line_t list with sexp


(********************************************************************************)
(**	{2 Public values and functions}						*)
(********************************************************************************)

val lang_of_string: string -> lang_t
val string_of_lang: lang_t -> string

