int gi;

int foo(int a, int b, int c)
{
	int i, j;

	i = 10;
	j = 50;
	a = i - j;
	b = j - i;
	c = a - (i + 10 * b);
	i = a + b * 4 - j / 2 - c;

	gi = i;
	return (i < 200);
}

int bar()
{
        int a,b;
	return foo(a+b, 10 + 4 * 5, 100) + (-20);
}

// calculate n!
int fact(int n)
{
	if (n == 0)
		return 1;
	else
		return n * fact(n - 1);
}

// calculate the n-th item of the fibonacci sequence
int fib(int n)
{
	int prev1, prev2, res;
	int i;

	if ( n <= 0 )
	{
		return 0;
	}
	
	if ( n <= 2 )
	{
		return 1;
	}
	else
	{
		i = 1;
		prev1 = 1;
		prev2 = 1;
		while ( i < n )
		{
			res = prev1 + prev2;
			prev1 = prev2;
			prev2 = res;
			i = i + 1;
		}
	}

	return res;
}

