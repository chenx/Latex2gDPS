#################################################
# Xin Chen. Feb., 2007
# @Last modified: 9/11/2007
#################################################
HYACC = /home/5/chenx/test/hyacc
C_SRC = dpfe_api.c symbol_table.c str.c lstr.c const.c \
        bst.c cov.c ilp.c ks01.c lcs.c lsp.c mcm.c odp.c rap.c \
        scp.c spa.c spc.c tsp.c wlv.c
SRC = pn.l pn.y $(C_SRC)
HDR = symbol_table.h pn.h str.h lstr.h const.h dpfe.h  \
      bst.h cov.h ilp.h ks01.h lcs.h lsp.h mcm.h odp.h rap.h \
      scp.h spa.h spc.h tsp.h wlv.h
TEST_FILE = io/* testcase/*
PACK_SRC = $(SRC) $(HDR) $(TEST_FILE) makefile readme test.pl update.pl
DATE = `date '+%m-%d-%y'`
PACK_NAME = pn_$(DATE).tar
RM_FILE = lex.yy.c y.tab.c y.tab.h y.parse 

pn: $(SRC) $(HDR)
	lex pn.l
	yacc -dv pn.y
	gcc -o pn lex.yy.c y.tab.c $(C_SRC)
	@rm -f $(RM_FILE)

clean:
	rm -f pn $(RM_FILE) y.output y.parse

hyacc: $(SRC) $(HDR)
	lex pn.l
	time $(HYACC) -dv pn.y 
	gcc -o pn lex.yy.c y.tab.c $(C_SRC)
	@rm -f $(RM_FILE)

hyaccv: $(SRC) $(HDR)
	lex pn.l
	time $(HYACC) -dvD2D1 pn.y
	gcc -o pn lex.yy.c y.tab.c $(C_SRC)

count:
	wc $(SRC) $(HDR)

# make a distribution
dist:
	@-rm -f $(PACK_NAME).gz
	@tar cvf $(PACK_NAME) $(PACK_SRC)
	@gzip $(PACK_NAME)
	@ls $(PACK_NAME).gz
	@echo pack successfully finishes

