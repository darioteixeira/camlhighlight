(********************************************************************************)
(*  camlhighlight_write_xhtml_duce.ml
  Copyright (c) 2010 Alexander Markov <apsheronets@gmail.com>
  This software is distributed under the terms of the GNU GPL version 2.
  See LICENSE file for full license text.
*)
(********************************************************************************)

open ExtList
open Xhtmltypes_duce
open Camlhighlight_core

let write
  ?(class_prefix = "hl_")
  ?(extra_classes = [])
  ?(dummy_lines = true)
  ?(linenums = false)
  code : {{ _div }} =

  let utf = Ocamlduce.Utf8.make (* OCamlduce's crutches *) in

  let make_class ?(extra_classes = []) names =
    List.fold_left (fun (acc:{{ attrs }}) x ->
        {{ acc ++ { class={: x :} } }} ) {{ { } }}
      (extra_classes @ (List.map (fun x -> class_prefix ^ x) names)) in

  let normal_line content =
    {{ [ '\n' <code ({{make_class ["line"]}})>content ] }} in

  let dummy =
    if dummy_lines then
    {{ [ '\n' <code ({{make_class ["line"; "dummy"]}})>[] ] }}
    else {{ [] }} in

  let class_of_special special =
    Sexplib.Sexp.to_string_mach (Camlhighlight_core.sexp_of_special_style_t special) in

  let elem_to_xhtml = function
    | (#normal_style_t, str) -> utf str
    | (#special_style_t as special, str) ->
        {{ [ <span ( {{ make_class [class_of_special special] }} )>(utf str) ] }} in

  let convert_nums () =
    let code_len = List.length code in
    let width = String.length (string_of_int code_len) in
    let numline_to_xhtml num = normal_line (utf (Printf.sprintf "%0*d" width num)) in
    let nums = List.init code_len (fun x -> x+1) in
    let numlines = List.map numline_to_xhtml nums in
    let content = {{
      dummy @
      {{ List.fold_left (fun (acc:{{ [(Char|phrase)*] }}) x ->
          {{ acc @ x }})
        {{ [] }} numlines }}
      @ dummy }} in
    {{ <pre ({{make_class ["nums"]}})>content }}

  and convert_code () =
    let codeline_to_xhtml line =
      normal_line
        (List.fold_left (fun (acc:{{ inlines }}) x ->
          {{ acc @ (elem_to_xhtml x) }}) {{ [] }} line)
    in {{ <pre ({{make_class ["code"]}})>
      (dummy @ {{
        List.fold_left (fun (acc:{{ [(Char|phrase)*] }} ) x ->
            {{ acc @ x }}) {{ [] }}
          (List.map codeline_to_xhtml code)
      }} @ dummy) }} in

  {{ <div ({{make_class ~extra_classes ["main"]}})>
    {{ match linenums with
      | true  -> {{ [ {{convert_nums ()}} {{convert_code ()}} ] }}
      | false -> {{ [ {{convert_code ()}} ] }} }} }}

