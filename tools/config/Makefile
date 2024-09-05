CC ?= gcc
MCONF_CFLAGS ?= -I.
MCONF_LDFLAGS ?= -lcurses 

common-objs	:= confdata.o expr.o lexer.yy.o parser.tab.o preprocess.o symbol.o
lxdialog	:= $(addprefix lxdialog/, checklist.o inputbox.o menubox.o textbox.o util.o yesno.o)
mconf-objs	:= mconf.o $(lxdialog) $(common-objs)

mconf: $(mconf-objs)
	$(CC)  $^ $(MCONF_LDFLAGS) -o $@

lexer.yy.c: lexer.l parser.tab.c
	flex -o $@ $<

parser.tab.c: parser.y
	bison -d $^

%.o: %.c
	$(CC) $(MCONF_CFLAGS) -c $^ -o $@

clean:
	rm -rf mconf
	rm -rf *.o lxdialog/*.o
	rm -rf parser.tab.c parser.tab.h lexer.yy.c
