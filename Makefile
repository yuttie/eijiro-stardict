SRC = $(wildcard EIJIRO/EIJI-*.TXT)
NAME = $(basename $(notdir $(SRC)))
STARDICT_TABFILE = stardict_tabfile

.PHONY: all clean

all: $(NAME).dict $(NAME).idx $(NAME).ifo
clean:
	rm -fv $(NAME).tabfile $(NAME).dict $(NAME).idx $(NAME).ifo

$(NAME).tabfile: $(SRC)
	ruby text2tabfile.rb $< > $@

%.dict %.idx %.ifo: %.tabfile
	$(STARDICT_TABFILE) $<
	sed -i 's/bookname=$*/bookname=英辞郎($*)/' $*.ifo
	sed -i 's/sametypesequence=m/sametypesequence=g/' $*.ifo
