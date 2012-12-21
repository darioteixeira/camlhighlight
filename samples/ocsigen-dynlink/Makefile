NAME=test
PKGS=lwt,ocsigen,camlhighlight

all: $(NAME).cma $(NAME).cmxs

$(NAME).cma: $(NAME).cmo
	ocamlc -a -o $@ $+

$(NAME).cmxs: $(NAME).cmxa
	ocamlopt -shared -linkall -I `pwd` -o $@ $<

$(NAME).cmxa: $(NAME).cmx
	ocamlopt -a -o $@ $+

$(NAME).cmo: $(NAME).ml
	ocamlfind ocamlc -thread -package $(PKGS) -c $<

$(NAME).cmx: $(NAME).ml
	ocamlfind ocamlopt -thread -package $(PKGS) -c $<

clean:
	rm -f $(NAME).cm[ioax] $(NAME).cmx[sa] $(NAME).[oa]

