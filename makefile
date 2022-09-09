BIN = parser
OUT = c-

CC = g++
CFLAGS = -Wall -g

SRCS = $(BIN).yy $(BIN).ll
HDRS = scanType.hpp
OBJS = lex.yy.o $(BIN).tab.o

$(BIN) : $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(OUT)

lex.yy.c : $(BIN).ll $(BIN).tab.hh $(HDRS)
	flex $(BIN).ll

$(BIN).tab.hh $(BIN).tab.cc : $(BIN).yy
	bison -v -t -d $(BIN).yy

clean :
	rm -f *~ $(OBJS) $(BIN) lex.yy.c $(BIN).tab.hh $(BIN).tab.cc $(BIN).output $(BIN).tar $(OUT)

tar : $(HDR) $(SRCS) makefile
	tar -cvf $(BIN).tar $(HDRS) $(SRCS) makefile