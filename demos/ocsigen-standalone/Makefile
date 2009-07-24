NAME=test
PKGS=extlib,lwt,ocsigen,camlhighlight
STATIC_PKGS=ocsigen.parsecommandline,ocsigen.server,ocsigen.ext.ocsipersist-sqlite,ocsigen.ext.eliom,ocsigen.ext.staticmod,extlib,camlhighlight

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

