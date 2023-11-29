(** Facilities for converting highlighted code into Tyxml's [Html]
    representation.
*)


(********************************************************************************)
(** {1 Public functors}                                                         *)
(********************************************************************************)

(** A functorial interface is used because the user may wish to use this module
    together with Eliom (for instance).  This particular use case is achieved by
    feeding Eliom's [Html.F.Raw] and [Eliom_content.Svg.F.Raw] to the functor,
    as exemplified by the code below:
    {v
    module My_writer = Camlhighlight_write_html.Make
    (struct
        include Eliom_content.Html.F.Raw
        module Svg = Eliom_content.Svg.F.Raw
    end)
    v}
*)
module Make: functor (Html: Html_sigs.NoWrap) ->
sig
    (** This function converts a value of type {!Camlhighlight_core.t} containing
        a syntax-highlighted document into a [Html] [span] element.  Note that
        the document must consist of a single line; otherwise an [Invalid_argument]
        exception is raised.  The optional parameter [class_prefix] indicates the
        prefix for the class names of all HTML elements produced, while [extra_classes]
        can be used to provide additional class names for the main container (these
        extra classes are not prefixed by [class_prefix]).
    *)
    val write_inline:
        ?class_prefix:string ->
        ?extra_classes:Html_types.nmtoken list ->
        Camlhighlight_core.t ->
        [> Html_types.span ] Html.elt

    (** This function converts a value of type {!Camlhighlight_core.t} containing
        a syntax-highlighted document into a [Html] [div] element.  The optional
        parameter [class_prefix] indicates the prefix for the class names of all
        HTML elements produced, while [extra_classes] can be used to provide
        additional class names for the main container (these extra classes are not
        prefixed by [class_prefix]).  Also optional are the boolean parameters
        [dummy_lines], and [linenums].  They indicate whether the generated HTML
        should include dummy lines at the beginning and end, and line numbers for
        the code, respectively.
    *)
    val write_block:
        ?class_prefix:string ->
        ?extra_classes:Html_types.nmtoken list ->
        ?dummy_lines:bool ->
        ?linenums:bool ->
        Camlhighlight_core.t ->
        [> Html_types.div ] Html.elt

    (** @deprecated [write] is an alias for {!write_block}. *)
    val write:
        ?class_prefix:string ->
        ?extra_classes:Html_types.nmtoken list ->
        ?dummy_lines:bool ->
        ?linenums:bool ->
        Camlhighlight_core.t ->
        [> Html_types.div ] Html.elt
        [@@ocaml.deprecated "Use write_block instead."]
end

