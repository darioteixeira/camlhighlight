(********************************************************************************)
(*	Camlhighlight_lowlevel.ml
	Copyright (c) 2010 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(**	This module provides a low-level interface to the C++ Highlight library.
	Normally, it should not be necessary to use it directly.  Please see
	Highlight's documentation for information about these types and functions.
*)

type generator_t

type output_type_t =
	| Html
	| Xhtml
	| Tex
	| Latex
	| Rtf
	| Xml
	| Ansi
	| Xterm256
	| Html32
	| Svg

type wrap_mode_t =
	| Wrap_disabled
	| Wrap_simple
	| Wrap_default

type load_result_t =
	| Load_failed
	| Load_failed_regex
	| Load_new
	| Load_none

external create: output_type_t -> generator_t = "create"
external init_theme: generator_t -> string -> bool = "init_theme"
external load_language: generator_t -> string -> load_result_t = "load_language"
external generate_string: generator_t -> string -> string = "generate_string"
external set_encoding: generator_t -> string -> unit = "set_encoding"
external set_fragment_code: generator_t -> bool -> unit = "set_fragment_code"
external set_preformatting: generator_t -> wrap_mode_t -> int -> int -> unit = "set_preformatting"
external get_style_name: generator_t -> string = "get_style_name"

