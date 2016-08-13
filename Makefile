SRC = $(wildcard EIJIRO/EIJI-*.TXT)
NAME = $(basename $(notdir $(SRC)))
STARDICT_TABFILE = stardict_tabfile

DESTDIR = $(HOME)

INSTALL = install
INSTALL_DATA = ${INSTALL} -m 644


.PHONY: all clean install

all: $(NAME).dict.dz $(NAME).idx $(NAME).ifo

clean:
	rm -fv $(NAME).tabfile $(NAME).dict.dz $(NAME).dict $(NAME).idx $(NAME).ifo

install: $(NAME).dict.dz $(NAME).idx $(NAME).ifo
	$(INSTALL) -d $(DESTDIR)/.stardict/dic/$(NAME)
	$(INSTALL_DATA) $^ $(DESTDIR)/.stardict/dic/$(NAME)

$(NAME).tabfile: $(SRC)
	ruby text2tabfile.rb $< > $@

%.dict.dz %.idx %.ifo: %.tabfile
	$(STARDICT_TABFILE) $<
	sed -i 's/bookname=$*/bookname=英辞郎($*)/' $*.ifo
	sed -i 's/sametypesequence=m/sametypesequence=g/' $*.ifo
