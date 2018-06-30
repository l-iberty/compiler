#include <stdio.h>

int fib(int n);

int main()
{
	for (int i = 0; i < 15; i++)
		printf("%d ", fib(i));
	printf("\n");
	return 0;
}
