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

type normal_style_t =
	[ `Nrm	(** normal *)
	] with sexp

type special_style_t =
	[ `Kwd	(** keyword *)
	| `Typ	(** type *) 
	| `Uty	(** usertype *)
	| `Str	(** string *)
	| `Rex	(** regexp *)
	| `Sch	(** specialchar *)
	| `Com	(** comment *)
	| `Num	(** number *)
	| `Pre	(** preproc *)
	| `Sym	(** symbol *)
	| `Fun	(** function *)
	| `Brk	(** cbracket *)
	| `Tod	(** todo *)
	] with sexp


(**	List of possible styles.
*)
type style_t = [ normal_style_t | special_style_t ] with sexp


(**	An element consists of a style and a string.
*)
type elem_t = style_t * string with sexp


(**	A line is composed of a list of {!elem_t}.
*)
type line_t = elem_t list with sexp


(**	The value of highlighted source-code samples.  It's just a list of lines.
*)
type t = line_t list with sexp

