(********************************************************************************)
(*  Camlhighlight_write_html.ml
    Copyright (c) 2010-2016 Dario Teixeira <dario.teixeira@nleyten.com>
    This software is distributed under the terms of the GNU GPL version 2.
    See LICENSE file for full license text.
*)
(********************************************************************************)

open Camlhighlight_core


(********************************************************************************)
(** {1 Private modules}                                                         *)
(********************************************************************************)

module List =
struct
    include List

    let init n f =
        let rec loop idx accum =
            if idx >= 0
            then
                let accum' = f idx :: accum in
                loop (idx - 1) accum'
            else
                accum in
        loop (n - 1) []
end


(********************************************************************************)
(** {1 Public functors}                                                         *)
(********************************************************************************)

module Make (Html: Html_sigs.NoWrap) =
struct
    open Html

    let make_class ~class_prefix ?(extra_classes = []) names =
        a_class (List.fold_right (fun x accum -> (class_prefix ^ x) :: accum) names extra_classes)

    let class_of_special special =
        Sexplib.Sexp.to_string_mach (Camlhighlight_core.sexp_of_special_style special)

    let elem_to_xhtml ~class_prefix = function
        | (#normal_style, str)             -> pcdata str
        | (#special_style as special, str) -> span ~a:[make_class ~class_prefix [class_of_special special]] [pcdata str]

    let write_inline ?(class_prefix = "hl_") ?extra_classes = function
        | [line] -> span ~a:[make_class ~class_prefix ?extra_classes ["inline"]] (List.map (elem_to_xhtml ~class_prefix) line)
        | _      -> invalid_arg "write_inline"

    let write_block ?(class_prefix = "hl_") ?extra_classes ?(dummy_lines = true) ?(linenums = false) source =
        let dummy = if dummy_lines then [pcdata "\n"; code ~a:[make_class ~class_prefix ["line"; "dummy"]] []] else [] in
        let normal_line content =
            [pcdata "\n"; code ~a:[make_class ~class_prefix ["line"]] content] in
        let convert_nums () =
            let source_len = List.length source in
            let width = String.length (string_of_int source_len) in
            let numline_to_xhtml num = normal_line [pcdata (Printf.sprintf "%0*d" width num)]
            in pre ~a:[make_class ~class_prefix ["nums"]] (dummy @ (List.flatten (List.map numline_to_xhtml (List.init source_len (fun x -> x+1)))) @ dummy)
        and convert_source () =
            let source_line_to_xhtml line = normal_line (List.map (elem_to_xhtml ~class_prefix) line)
            in pre ~a:[make_class ~class_prefix ["code"]] (dummy @ (List.flatten (List.map source_line_to_xhtml source)) @ dummy)
        in div ~a:[make_class ~class_prefix ?extra_classes ["block"]]
            (match linenums with
                | true  -> [convert_nums (); convert_source ()]
                | false -> [convert_source ()])

        let write = write_block
end

