#include <stdio.h>

int foo(int a, int b, int c);
int fact(int n);
int fib(int n);

extern int gi;

int main()
{
	printf("foo(5, 9, 23): %d\n", foo(5, 9, 23));
	printf("gi: %d\n", gi);
	printf("fact(6): %d\n", fact(6));
	printf("fib(30): %d\n", fib(30));
}
