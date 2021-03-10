# Makefile MINE

.PHONY: clean

all: ./concat.out

concat.out: main.S
	 arm-linux-gnueabi-gcc $< -o $@ -ggdb3 -static

clean:
	rm -f concat.out

