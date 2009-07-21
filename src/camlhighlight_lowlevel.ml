(********************************************************************************)
(*	Camlhighlight_lowlevel.ml
	Copyright (c) 2009 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(**	This module provides a low-level interface to the C++ Highlight library.
	Normally, it should not be necessary to use it directly.
*)

type generator_t

type load_result_t =
	| Load_failed
	| Load_failed_regex
	| Load_new
	| Load_none

external create: unit -> generator_t = "create"
external init_theme: generator_t -> string -> bool = "init_theme"
external load_language: generator_t -> string -> load_result_t = "load_language"
external generate_string: generator_t -> string -> string = "generate_string"
external set_encoding: generator_t -> string -> unit = "set_encoding"
external set_fragment_code: generator_t -> bool -> unit = "set_fragment_code"

