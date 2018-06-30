./vc test.c
./asm test.cas
nasm out.asm -f elf -o out.o
gcc main.c -c -m32
gcc main.o out.o -o test -m32
./test
