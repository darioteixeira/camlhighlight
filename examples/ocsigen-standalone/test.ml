(********************************************************************************)
(*  Test.ml
    Copyright (c) 2010-2014 Dario Teixeira (dario.teixeira@yahoo.com)
    This software is distributed under the terms of the GNU GPL version 2.
    See LICENSE file for full license text.
*)
(********************************************************************************)

(*  Demo of Camlhighlight library with standalone Eliom application.
*)

open Eliom_content
open Html.F


module Html_writer = Camlhighlight_write_html.Make
(struct
    include Eliom_content.Html.F.Raw
    module Svg = Eliom_content.Svg.F.Raw
end)


let (!!) = Lazy.force


let inline_service =
    lazy (Eliom_service.Http.service 
        ~path: ["inline"]
        ~get_params: Eliom_parameter.unit
        ())


let block_service =
    lazy (Eliom_service.Http.service 
        ~path: ["block"]
        ~get_params: Eliom_parameter.unit
        ())


let main_service =
    lazy (Eliom_service.Http.service 
        ~path: []
        ~get_params: Eliom_parameter.unit
        ())


let inline_handler () () =
    let () = Camlhighlight_parser.set_tabspaces 8 in
    let str = "type foo = One | Two | Three" in
    let hilite = Camlhighlight_parser.from_string ~lang:"caml" str in
    let sexp = Camlhighlight_core.sexp_of_t hilite in
    let sexp_str = Sexplib.Sexp.to_string_hum sexp in
    let hilite_xhtml = Html_writer.write_inline hilite in
    let hilite_str =
        let buf = Buffer.create 100 in
        Html.Printer.print_list ~output:(Buffer.add_string buf) [hilite_xhtml];
        Buffer.contents buf in
    let css_uri = make_uri (Eliom_service.static_dir ()) ["css"; "highlight.css"] in
    Lwt.return
        (html
            (head (title (pcdata "Inline Test")) [css_link ~a:[(a_media [`All]); (a_title "Default")] ~uri:css_uri ()])
            (body
                [
                h1 [pcdata "Original source:"]; pre [pcdata str];
                h1 [pcdata "S-expression:"]; pre [pcdata sexp_str];
                h1 [pcdata "Raw HTML5:"]; pre [pcdata hilite_str];
                h1 [pcdata "Rendered HTML5 (within paragraph):"]; p [pcdata "Hello "; hilite_xhtml; pcdata " World"];
                ]))


let block_handler () () =
    let ch = open_in "sample.ml" in
    let str = BatPervasives.input_all ch in
    let () = close_in ch in
    let () = Camlhighlight_parser.set_tabspaces 8 in
    let hilite = Camlhighlight_parser.from_string ~lang:"caml" str in
    let sexp = Camlhighlight_core.sexp_of_t hilite in
    let sexp_str = Sexplib.Sexp.to_string_hum sexp in
    let hilite_xhtml = Html_writer.write_block ~linenums:true ~extra_classes:["hl_zebra"] hilite in
    let hilite_str =
        let buf = Buffer.create 100 in
        Html.Printer.print_list ~output:(Buffer.add_string buf) [hilite_xhtml];
        Buffer.contents buf in
    let css_uri = make_uri (Eliom_service.static_dir ()) ["css"; "highlight.css"] in
    Lwt.return
        (html
            (head (title (pcdata "Block Test")) [css_link ~a:[(a_media [`All]); (a_title "Default")] ~uri:css_uri ()])
            (body
                [
                h1 [pcdata "Original source:"]; pre [pcdata str];
                h1 [pcdata "S-expression:"]; pre [pcdata sexp_str];
                h1 [pcdata "Raw HTML5:"]; pre [pcdata hilite_str];
                h1 [pcdata "Rendered HTML5:"]; hilite_xhtml;
                ]))


let main_handler () () =
    Lwt.return
        (html
            (head (title (pcdata "Main Test")) [])
            (body
                [
                h1 [a !!inline_service [pcdata "Inline test"] ()];
                h1 [a !!block_service [pcdata "Block test"] ()];
                ]))


let register () =
    Eliom_registration.Html.register !!inline_service inline_handler;
    Eliom_registration.Html.register !!block_service block_handler;
    Eliom_registration.Html.register !!main_service main_handler


let () =
    Eliom_service.register_eliom_module "test" register;
    Ocsigen_server.start_server ()

