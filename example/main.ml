open XHTML.M

(* --------------------------------------------------------------------	*)
(* Service "coucou".							*)
(* --------------------------------------------------------------------	*)

let source1 = Std.input_all (open_in "main.ml")
let source2 = Std.input_all (open_in "libmathml2dtd_stubs.c")

let hilite1 = Highlight.from_string "ml" source1
let hilite2 = Highlight.from_string "c" source2

let hilite_xhtml1 = Highlight.to_xhtml ~linenums:true ~fancy:true hilite1
let hilite_xhtml2 = Highlight.to_xhtml ~linenums:true ~fancy:true hilite2

let coucou_handler sp () () =
	let css_uri = Eliom_predefmod.Xhtml.make_uri (Eliom_services.static_dir sp) sp ["css"; "highlight.css"]
	in Lwt.return
		(html
			(head (title (pcdata "Test")) [Eliom_predefmod.Xhtml.css_link ~a:[(a_media [`All]); (a_title "Default")] ~uri:css_uri ()])
			(body	[
				hilite_xhtml1;
				hilite_xhtml2;
				]))

let coucou_service =
	Eliom_predefmod.Xhtml.register_new_service 
		~path: [""]
		~get_params: Eliom_parameters.unit
		coucou_handler

let ola1 = 10

let ola2 = 20.123

let ola3 = "This is a string with \n escaped characters"

type foo_t =
	| One
	| Two
	| Three

type bar_t =
	[ `One
	| `Two
	| `Three
	]
