(********************************************************************************)
(*	test.ml
	Copyright (c) 2010 Alexander Markov <apsheronets@gmail.com>
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(*	Ocsigen demo of Camlhighlight library.
*)

open Eliom_duce


let test_service =
	Eliom_services.new_service
		~path: [""]
		~get_params: Eliom_parameters.unit
		()


let test_handler sp () () =
	let ch = open_in "test.ml" in
	let str = Std.input_all ch in
	let () = close_in ch in
	let () = Camlhighlight_parser.set_tabspaces 8 in
	let hilite = Camlhighlight_parser.from_string ~lang:"caml" str in
	let hilite_xhtml = Camlhighlight_write_xhtml_duce.write ~linenums:true ~extra_classes:["hl_zebra"] hilite in
	let css_uri = Xhtml.make_uri (Eliom_services.static_dir sp) sp ["css"; "highlight.css"]
	in Lwt.return
    {{ <html xmlns="http://www.w3.org/1999/xhtml">[
      <head>[
        <meta http-equiv="content-type" content="text/html; charset=UTF-8">[]
        <title>"Test" {{ Xhtml.css_link ~a:{{ {media="all" title="default"} }} ~uri:css_uri () }} ]
      <body>[hilite_xhtml] ] }}


let () = Xhtml.register test_service test_handler


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

