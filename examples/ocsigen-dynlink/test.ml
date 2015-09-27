(********************************************************************************)
(*  Test.ml
    Copyright (c) 2010-2014 Dario Teixeira (dario.teixeira@yahoo.com)
    This software is distributed under the terms of the GNU GPL version 2.
    See LICENSE file for full license text.
*)
(********************************************************************************)

(*  Demo of Camlhighlight library with regular (dynlinked) Eliom application.
*)

open Eliom_content
open Html5.F


module Html5_writer = Camlhighlight_write_html5.Make
(struct
    include Eliom_content.Html5.F.Raw
    module Svg = Eliom_content.Svg.F.Raw
end)


let test_service =
    Eliom_service.Http.service 
        ~path:[]
        ~get_params:Eliom_parameter.unit
        ()


let test_handler () () =
    let ch = open_in "sample.ml" in
    let str = BatPervasives.input_all ch in
    let () = close_in ch in
    let () = Camlhighlight_parser.set_tabspaces 8 in
    let hilite = Camlhighlight_parser.from_string ~lang:"caml" str in
    let sexp = Camlhighlight_core.sexp_of_t hilite in
    let sexp_str = Sexplib.Sexp.to_string_hum sexp in
    let hilite_xhtml = Html5_writer.write ~linenums:true ~extra_classes:["hl_zebra"] hilite in
    let hilite_str =
        let buf = Buffer.create 100 in
        Html5.Printer.print_list ~output:(Buffer.add_string buf) [hilite_xhtml];
        Buffer.contents buf in
    let css_uri = make_uri (Eliom_service.static_dir ()) ["css"; "highlight.css"] in
    Lwt.return
        (html
            (head (title (pcdata "Test")) [css_link ~a:[(a_media [`All]); (a_title "Default")] ~uri:css_uri ()])
            (body   [
                h1 [pcdata "Original source:"];
                pre [pcdata str];
                h1 [pcdata "S-expression:"];
                pre [pcdata sexp_str];
                h1 [pcdata "Raw HTML5:"];
                pre [pcdata hilite_str];
                h1 [pcdata "Rendered HTML5:"];
                hilite_xhtml;
                ]))


let () =
    Eliom_registration.Html5.register test_service test_handler

