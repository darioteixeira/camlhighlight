NAME=test
PKGS=sexplib,batteries,lwt,eliom.server,camlhighlight
STATIC_PKGS=sexplib,batteries,ocsigenserver,ocsigenserver.commandline,ocsigenserver.ext.ocsipersist-sqlite,ocsigenserver.ext.staticmod,lwt,eliom.server,camlhighlight

all: $(NAME).byte $(NAME).native

$(NAME).byte: $(NAME).cmo
	ocamlfind ocamlc -package $(STATIC_PKGS) $+ -o $@ -linkpkg -thread

$(NAME).native: $(NAME).cmx
	ocamlfind ocamlopt -package $(STATIC_PKGS) $+ -o $@ -linkpkg -thread

%.cmo: %.ml
	ocamlfind ocamlc -thread -package $(PKGS) -c $<

%.cmx: %.ml
	ocamlfind ocamlopt -thread -package $(PKGS) -c $<

clean:
	rm -f $(NAME).cm[ioax] $(NAME).cmx[as] $(NAME).[oa] $(NAME).byte $(NAME).native

