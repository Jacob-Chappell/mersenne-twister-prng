CFLAGS = -std=c99 -g -Wall -Wshadow --pedantic -Wvla -Werror
GCC = gcc $(CFLAGS)
EXEC = gen_random
OUTFILE = output.bin
STATEFILE = startState.bin

$(EXEC): gen_random.o mt.o mt.h
	$(GCC) gen_random.o mt.o mt.h -o $(EXEC)

test_50k: $(EXEC) gen_start
	./$(EXEC) 50000 $(STATEFILE) $(OUTFILE)

gen_start: gen_start_state.o
	$(GCC) gen_start_state.o -o gen_start
	./gen_start $(STATEFILE)

%.o: %.c
	$(GCC) -c $<

clean:
	rm $(EXEC) | rm *.o | rm $(OUTFILE) | rm $(STATEFILE) | rm gen_start
