NAME=test
PKGS=extlib,lwt,eliom.server,camlhighlight
STATIC_PKGS=ocsigenserver,ocsigenserver.commandline,ocsigenserver.ext.ocsipersist-sqlite,ocsigenserver.ext.staticmod,eliom.server,extlib,camlhighlight

all: $(NAME) $(NAME).opt

$(NAME): $(NAME).cmo
	ocamlfind ocamlc -package $(STATIC_PKGS) $+ -o $@ -linkpkg -thread

$(NAME).opt: $(NAME).cmx
	ocamlfind ocamlopt -package $(STATIC_PKGS) $+ -o $@ -linkpkg -thread

%.cmo: %.ml
	ocamlfind ocamlc -thread -package $(PKGS) -c $<

%.cmx: %.ml
	ocamlfind ocamlopt -thread -package $(PKGS) -c $<

clean:
	rm -f $(NAME).cm[ioax] $(NAME).cmx[as] $(NAME).[oa] $(NAME) $(NAME).opt

