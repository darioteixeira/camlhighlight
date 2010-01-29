(********************************************************************************)
(*	main.ml
	Copyright (c) 2010 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(*	Demos of Camlhighlight library with Ocsigen standalone server.
*)

open XHTML.M


let test_service =
	lazy (Eliom_services.new_service 
		~path: [""]
		~get_params: Eliom_parameters.unit
		())


let test_handler sp () () =
	let ch = open_in "test.ml" in
	let str = Std.input_all ch in
	let () = close_in ch in
	let hilite = Camlhighlight_parser.from_string ~lang:"ml" str in
	let hilite_xhtml = Camlhighlight_write_xhtml.write ~linenums:true ~extra_classes:["hl_zebra"] hilite in
	let css_uri = Eliom_predefmod.Xhtml.make_uri (Eliom_services.static_dir sp) sp ["css"; "highlight.css"]
	in Lwt.return
		(html
			(head (title (pcdata "Test")) [Eliom_predefmod.Xhtml.css_link ~a:[(a_media [`All]); (a_title "Default")] ~uri:css_uri ()])
			(body [hilite_xhtml]))


let register () =
	Eliom_predefmod.Xhtml.register (Lazy.force test_service) test_handler


let () =
	Eliom_services.register_eliom_module "test" register;
	Ocsigen_server.start_server ()


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

