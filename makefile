BIN = parser
OUT = c-

CC = g++
CFLAGS = -Wall -g

HDRS = scanType.hh
SRCS = $(BIN).yy $(BIN).ll
OBJS = lex.yy.o $(BIN).tab.o
DOCS = c-grammar.pdf

$(BIN) : $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(OUT)

lex.yy.c : $(BIN).ll $(BIN).tab.hh $(HDRS)
	flex $(BIN).ll

$(BIN).tab.hh $(BIN).tab.cc : $(BIN).yy
	bison -v -t -d $(BIN).yy

clean :
	rm -f *~ $(OBJS) $(BIN) lex.yy.c $(BIN).tab.hh $(BIN).tab.cc $(BIN).output $(BIN).tar 

tar : $(HDR) $(SRCS) makefile
	tar -cvf $(BIN).tar $(HDRS) $(SRCS) makefile
