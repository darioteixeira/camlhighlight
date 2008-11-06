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

type t = string * line_t list with sexp


(********************************************************************************)
(**	{2 Public functions}							*)
(********************************************************************************)

val from_string : string -> string -> t

val to_xhtml : ?linenums:bool -> ?zebra:bool -> ?prefix:string -> t -> [> `Div ] XHTML.M.elt

