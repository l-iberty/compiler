./tac test.c
./asm test.tac
nasm out.asm -f elf -o out.o
gcc main.c -c -m32
gcc main.o out.o -o test -m32
./test
