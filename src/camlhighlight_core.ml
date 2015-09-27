(********************************************************************************)
(*  Camlhighlight_core.ml
    Copyright (c) 2010-2014 Dario Teixeira (dario.teixeira@yahoo.com)
    This software is distributed under the terms of the GNU GPL version 2.
    See LICENSE file for full license text.
*)
(********************************************************************************)

open Sexplib.Std


(********************************************************************************)
(** {1 Type definitions}                                                        *)
(********************************************************************************)

type lang = string with sexp

type normal_style =
    [ `Norm
    ] with sexp

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
    ] with sexp

type style = [ normal_style | special_style ] with sexp

type elem = style * string with sexp

type line = elem list with sexp

type t = line list with sexp

