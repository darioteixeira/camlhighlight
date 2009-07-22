(********************************************************************************)
(*	main.ml
	Copyright (c) 2009 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(*	Basic demo of Camlhighlight library.
*)

open XHTML.M


(********************************************************************************)
(* Definition of the Ocsigen service that displays the highlighted source code.	*)
(********************************************************************************)

let source1 =
	let ch = open_in "test.ml" in
	let str = Std.input_all ch in
	close_in ch;
	str

let hilite1 = Camlhighlight_parser.from_string "ml" source1

let hilite_xhtml1 = Camlhighlight_write_xhtml.write ~linenums:true ~zebra:true hilite1

let test_handler sp () () =
	let css_uri = Eliom_predefmod.Xhtml.make_uri (Eliom_services.static_dir sp) sp ["css"; "highlight.css"]
	in Lwt.return
		(html
			(head (title (pcdata "Test")) [Eliom_predefmod.Xhtml.css_link ~a:[(a_media [`All]); (a_title "Default")] ~uri:css_uri ()])
			(body	[hilite_xhtml1]))

let test_service =
	Eliom_predefmod.Xhtml.register_new_service 
		~path: [""]
		~get_params: Eliom_parameters.unit
		test_handler


(********************************************************************************)
(* The following code does nothing; it is used to illustrate how the syntax	*)
(* highlighter colours different categories of syntactical elements.		*)
(********************************************************************************)

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

