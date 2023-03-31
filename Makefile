CFLAGS = -std=c99 -g -Wall -Wshadow --pedantic -Wvla -Werror
GCC = gcc $(CFLAGS)
EXEC = gen_random
OUTFILE = output
STATEFILE = startState

$(EXEC): gen_random.o mt.o mt.h clean
	$(GCC) gen_random.o mt.o mt.h -o $(EXEC)

test_50k_ascii: $(EXEC) gen_start_ascii
	./$(EXEC) 50000 $(STATEFILE).txt $(OUTFILE).txt a

test_50k_binary: $(EXEC) gen_start_binary
	./$(EXEC) 50000 $(STATEFILE).bin $(OUTFILE).bin b

test_10_binary: $(EXEC) gen_start_binary
	./$(EXEC) 10 $(STATEFILE).bin $(OUTFILE).bin b

test_10_ascii: $(EXEC) gen_start_ascii
	./$(EXEC) 10 $(STATEFILE).txt $(OUTFILE).txt a

gen_start_binary: gen_start_state.o clean
	$(GCC) gen_start_state.o -o gen_start
	./gen_start $(STATEFILE).bin b

gen_start_ascii: gen_start_state.o clean
	$(GCC) gen_start_state.o -o gen_start
	./gen_start $(STATEFILE).txt a

%.o: %.c
	$(GCC) -c $<

clean:
	rm $(EXEC) | rm *.o | rm $(OUTFILE).* | rm $(STATEFILE).* | rm gen_start
