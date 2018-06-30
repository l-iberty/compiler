.PHONY: all clean

TEST_IN=	test1.c
CFLAGS_C=	-c -m32
CFLAGS_S=	-S -m32

all: $(TEST_IN)
	gcc $< $(CFLAGS_S)
	gcc $< $(CFLAGS_C)

clean:
	rm -f *.o *.s
