(********************************************************************************)
(*	Interface file for Highlight.

	Copyright (c) 2008 Dario Teixeira (dario.teixeira@yahoo.com)

	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(**	The [Highlight] module provides facilities for parsing and pretty-printing
	source code.
*)

(********************************************************************************)
(**	{2 Public types}							*)
(********************************************************************************)

type lang_t =
	| Lang_c
	| Lang_ocaml
	with sexp

type special_t =
	| Num
	| Esc
	| Str
	| Dstr
	| Slc
	| Com
	| Dir
	| Sym
	| Kwa
	| Kwb
	| Kwc
	| Kwd
	with sexp

type elem_t =
	| Default of string
	| Special of special_t * string
	with sexp

type line_t = elem_t list with sexp

type t = lang_t option * line_t list with sexp

(********************************************************************************)
(**	{2 Public exceptions}							*)
(********************************************************************************)

exception Unknown_language of string


(********************************************************************************)
(**	{2 Public functions}							*)
(********************************************************************************)

val lang_of_string : string -> lang_t

val from_string : lang_t option -> string -> t

val to_xhtml : ?class_prefix:string -> ?extra_classes:XHTML.M.nmtoken list -> ?numbered:bool -> ?zebra:bool -> t -> [> `Div ] XHTML.M.elt

