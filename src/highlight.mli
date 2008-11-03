(********************************************************************************)
(*	Interface file for the Camlhighlight library.

	Copyright (c) 2008 Dario Teixeira (dario.teixeira@yahoo.com)

	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

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

type elem_t =
	| Default of string
	| Special of special_t * string

type line_t = elem_t list

type t = line_t list


(********************************************************************************)
(**	{2 Public functions}							*)
(********************************************************************************)

val from_string : string -> string -> t

val to_xhtml : ?linenums:bool -> ?fancy:bool -> t -> [> `Div ] XHTML.M.elt

val output_highlight : out_channel -> t -> unit

