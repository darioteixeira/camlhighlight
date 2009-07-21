(********************************************************************************)
(*	Camlhighlight_core.ml
	Copyright (c) 2009 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

TYPE_CONV_PATH "Camlhighlight_core"


(********************************************************************************)
(**	{2 Public types}							*)
(********************************************************************************)

(**	The highlighted language.
*)
type lang_t = string with sexp, bin_io


(**	The various kinds of syntactically meaningful tokens recognised
	by the highlighter.
*)
type special_t =
	| Num		(** Number *)
	| Esc		(** Escaped character *)
	| Str		(** String *)
	| Dstr		(** String directive *)
	| Slc		(** Single line comment *)
	| Com		(** Regular comment *)
	| Dir		(** Compiler directive *)
	| Sym		(** Symbol *)
	| Kwa		(** Keyword class A *)
	| Kwb		(** Keyword class B *)
	| Kwc		(** Keyword class C *)
	| Kwd		(** Keyword class D *)
	with sexp, bin_io


(**	Any individual element in the source code is either a "boring" value
	using the [Default] colour, or it's a [Special] value that should be
	highlight in a different colour.
*)
type elem_t =
	| Default of string
	| Special of special_t * string
	with sexp, bin_io


(**	A line is composed of a list of {!elem_t}.
*)
type line_t = elem_t list with sexp, bin_io


(**	The value of highlighted source-code samples.  It's a tuple consisting
	of the sample's language represented as [lang_t option], and a list of
	the sample's lines.
*)
type t = lang_t option * line_t list with sexp, bin_io

