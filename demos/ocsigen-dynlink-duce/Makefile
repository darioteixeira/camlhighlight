NAME=test
PKGS=lwt,ocsigen,camlhighlight

all: $(NAME).cma $(NAME).cmxs

$(NAME).cma: $(NAME).cmo
	ocamlducec -a -o $@ $+

$(NAME).cmxs: $(NAME).cmxa
	ocamlduceopt -shared -linkall -I `pwd` -o $@ $<

$(NAME).cmxa: $(NAME).cmx
	ocamlduceopt -a -o $@ $+

$(NAME).cmo: $(NAME).ml
	ocamlducefind ocamlc -thread -package $(PKGS) -c $<

$(NAME).cmx: $(NAME).ml
	ocamlducefind ocamlopt -thread -package $(PKGS) -c $<

clean:
	rm -f $(NAME).cm[ioax] $(NAME).cmx[sa] $(NAME).[oa]

