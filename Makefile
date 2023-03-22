CFLAGS = -std=c99 -g -Wall -Wshadow --pedantic -Wvla -Werror
GCC = gcc $(CFLAGS)
EXEC = gen_random
OUTFILE = output

$(EXEC): gen_random.o mt.o mt.h
	$(GCC) gen_random.o mt.o mt.h -o $(EXEC)

test_50k: $(EXEC)
	./$(EXEC) 50000 $(OUTFILE)

%.o: %.c
	$(GCC) -c $<

clean:
	rm $(EXEC) | rm *.o | rm $(OUTFILE)
