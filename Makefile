CFLAGS = -std=c99 -g -Wall -Wshadow --pedantic -Wvla -Werror
GCC = gcc $(CFLAGS)
EXEC = gen_random
OUTFILE = output.txt

$(EXEC): gen_random.o mt.o mt.h
	$(GCC) gen_random.o mt.o mt.h -o $(EXEC)

test_10: $(EXEC)
	./$(EXEC) 10 $(OUTFILE)

%.o: %.c
	$(GCC) -c $<

clean:
	rm $(EXEC) | rm *.o | rm $(OUTFILE)
