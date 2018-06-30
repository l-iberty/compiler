int fib(int n)
{
	int i;
	int prev1, prev2, res;

	if ( n <= 0 )
		return 0;

	if ( n <= 2)
	{
		return 1;
	}
	else
	{
		prev1 = 1;
		prev2 = 1;
		for (i = 3; i <= n; i = i + 1)
		{
			res = prev1 + prev2;
			prev1 = prev2;
			prev2 = res;
		}
	}
	return res;
}
