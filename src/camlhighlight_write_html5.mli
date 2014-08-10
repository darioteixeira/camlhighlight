(********************************************************************************)
(*	Camlhighlight_write_html5.mli
	Copyright (c) 2010-2014 Dario Teixeira (dario.teixeira@yahoo.com)
	This software is distributed under the terms of the GNU GPL version 2.
	See LICENSE file for full license text.
*)
(********************************************************************************)

(**	Facilities for converting highlighted code into Tyxml's [Html5]
	representation.
*)


(********************************************************************************)
(**	{2 Public functors}							*)
(********************************************************************************)

(**	A functorial interface is used because the user may wish to use this module
	together with Eliom (for instance).  This particular use case is achieved by
	feeding Eliom's [Html5.F.Raw] and [Eliom_content.Svg.F.Raw] to the functor,
	as examplified by the code below:
	{v
	module My_writer = Camlhighlight_write_html5.Make
	(struct
		include Eliom_content.Html5.F.Raw
		module Svg = Eliom_content.Svg.F.Raw
	end)
	v}
*)
module Make: functor (Html5: Html5_sigs.T with type 'a Xml.wrap = 'a and type 'a wrap = 'a and type 'a list_wrap = 'a list) ->
sig
	val write:
		?class_prefix:string ->
		?extra_classes:Html5_types.nmtoken list ->
		?dummy_lines:bool ->
		?linenums:bool ->
		Camlhighlight_core.t ->
		[> Html5_types.div ] Html5.elt
end

