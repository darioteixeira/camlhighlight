(********************************************************************************)
(*	test.ml
	Copyright (c) 2010 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(*	Ocsigen demo of Camlhighlight library.
*)

open Eliom_content
open Html5.F


let test_service =
	Eliom_service.service 
		~path: []
		~get_params: Eliom_parameter.unit
		()


let test_handler () () =
	let ch = open_in "sample.ml" in
	let str = BatPervasives.input_all ch in
	let () = close_in ch in
	let () = Camlhighlight_parser.set_tabspaces 8 in
	let hilite = Camlhighlight_parser.from_string ~lang:"caml" str in
	let sexp = Camlhighlight_core.sexp_of_t hilite in
	let sexp_str = Sexplib.Sexp.to_string_hum sexp in
	let hilite_xhtml = Camlhighlight_write_html5.write ~linenums:true ~extra_classes:["hl_zebra"] hilite in
	let hilite_str =
		let buf = Buffer.create 100 in
		Html5.Printer.print_list ~output:(Buffer.add_string buf) [hilite_xhtml];
		Buffer.contents buf in
	let css_uri = make_uri (Eliom_service.static_dir ()) ["css"; "highlight.css"]
	in Lwt.return
		(html
			(head (title (pcdata "Test")) [css_link ~a:[(a_media [`All]); (a_title "Default")] ~uri:css_uri ()])
			(body	[
				h1 [pcdata "Original source:"];
				pre [pcdata str];
				h1 [pcdata "S-expression:"];
				pre [pcdata sexp_str];
				h1 [pcdata "Raw HTML5:"];
				pre [pcdata hilite_str];
				h1 [pcdata "Rendered HTML5:"];
				hilite_xhtml;
				]))


let () = Eliom_registration.Html5.register test_service test_handler


(********************************************************************************)

(**	The following code does nothing; it is used to illustrate the syntax
	highlighting on different language elements.
*)

let ola1 = 10

let ola2 = 20.123

let ola3 = "This is a string with \n escaped characters"

type rec_t =
	{
	bye1: string;
	bye2: float;
	}

type foo_t =
	| One
	| Two
	| Three

type bar_t =
	[ `One
	| `Two
	| `Three
	]

