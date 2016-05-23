(********************************************************************************)
(*  Camlhighlight_core.ml
    Copyright (c) 2010-2016 Dario Teixeira <dario.teixeira@nleyten.com>
    This software is distributed under the terms of the GNU GPL version 2.
    See LICENSE file for full license text.
*)
(********************************************************************************)

open Sexplib.Std


(********************************************************************************)
(** {1 Type definitions}                                                        *)
(********************************************************************************)

type lang = string [@@deriving sexp]

type normal_style = [ `Norm ] [@@deriving sexp]

type special_style =
    [ `Kwd
    | `Type
    | `Utyp
    | `Str
    | `Rex
    | `Sch
    | `Com
    | `Num
    | `Prep
    | `Sym
    | `Fun
    | `Cbrk
    | `Pvar
    | `Pfun
    | `Clas
    | `Line
    | `Url
    | `Date
    | `Time
    | `File
    | `Ip
    | `Name
    | `Var
    | `Ital
    | `Bold
    | `Undr
    | `Fixd
    | `Arg
    | `Oarg
    | `Math
    | `Bibx
    | `Old
    | `New
    | `Diff
    | `Sel
    | `Prop
    | `Val
    | `Atom
    | `Meta
    ] [@@deriving sexp]

type style = [ normal_style | special_style ] [@@deriving sexp]

type elem = style * string [@@deriving sexp]

type line = elem list [@@deriving sexp]

type t = line list [@@deriving sexp]

