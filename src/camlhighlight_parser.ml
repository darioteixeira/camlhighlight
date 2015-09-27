(********************************************************************************)
(*  Camlhighlight_parser.ml
    Copyright (c) 2010-2014 Dario Teixeira (dario.teixeira@yahoo.com)
    This software is distributed under the terms of the GNU GPL version 2.
    See LICENSE file for full license text.
*)
(********************************************************************************)

open Sexplib

module String = BatString


(********************************************************************************)
(** {1 Exceptions}                                                              *)
(********************************************************************************)

exception Cannot_initialize_hiliter
exception Cannot_initialize_mapper
exception Uninitialized
exception Unknown_language of Camlhighlight_core.lang
exception Hiliter_error of string


(********************************************************************************)
(** {1 Private values and functions}                                            *)
(********************************************************************************)

external init_hiliter: unit -> unit = "init_hiliter"
external init_mapper: unit -> unit = "init_mapper"
external set_tabspaces: int -> unit = "set_tabspaces"
external get_langs: unit -> string list = "get_langs"
external has_mapping: string -> bool = "has_mapping"
external highlight: string -> string -> string = "highlight"


(********************************************************************************)
(** {1 Public values and functions}                                             *)
(********************************************************************************)

let set_tabspaces = set_tabspaces

let get_available_langs = get_langs

let is_available_lang = has_mapping

let from_string ?(lang = "txt") source =
    let conv_style = function
        | "normal"           -> `Norm
        | "keyword"          -> `Kwd
        | "type"             -> `Type
        | "usertype"         -> `Utyp
        | "string"           -> `Str
        | "regexp"           -> `Rex
        | "specialchar"      -> `Sch
        | "comment"          -> `Com
        | "number"           -> `Num
        | "preproc"          -> `Prep
        | "symbol"           -> `Sym
        | "function"         -> `Fun
        | "cbracket"         -> `Cbrk
        | "predef_var"       -> `Pvar
        | "predef_func"      -> `Pfun
        | "classname"        -> `Clas
        | "linenum"          -> `Line
        | "url"              -> `Url
        | "date"             -> `Date
        | "time"             -> `Time
        | "file"             -> `File
        | "ip"               -> `Ip
        | "name"             -> `Name
        | "variable"         -> `Var
        | "italics"          -> `Ital
        | "bold"             -> `Bold
        | "underline"        -> `Undr
        | "fixed"            -> `Fixd
        | "argument"         -> `Arg
        | "optionalargument" -> `Oarg
        | "math"             -> `Math
        | "bibtex"           -> `Bibx
        | "oldfile"          -> `Old
        | "newfile"          -> `New
        | "difflines"        -> `Diff
        | "selector"         -> `Sel
        | "property"         -> `Prop
        | "value"            -> `Val
        | "atom"             -> `Atom
        | "meta"             -> `Meta
        | _                  -> `Norm in
    let elem_of_sexp = function
        | Sexp.List [Sexp.Atom s; Sexp.Atom c] -> (conv_style s, c)
        | _                                    -> failwith "elem_of_sexp" in
    let line_of_sexp = function
        | Sexp.List l -> List.map elem_of_sexp l
        | _           -> failwith "line_of_sexp" in
    let lines = String.nsplit (highlight lang source) "\n" in
    let conv line = line_of_sexp (Sexp.of_string ("(" ^ line ^ ")"))
    in List.map conv lines


(********************************************************************************)
(** {1 Module initialisation}                                                   *)
(********************************************************************************)

let () =
    Callback.register_exception "Cannot_initialize_hiliter" Cannot_initialize_hiliter;
    Callback.register_exception "Cannot_initialize_mapper" Cannot_initialize_mapper;
    Callback.register_exception "Uninitialized" Uninitialized;
    Callback.register_exception "Unknown_language" (Unknown_language "");
    Callback.register_exception "Hiliter_error" (Hiliter_error "");
    init_hiliter ();
    init_mapper ()

