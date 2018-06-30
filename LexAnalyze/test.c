int aaa, bbb, ccc;

void init()
{
	aaa = 123;
	bbb = 10;
	ccc = 80;
}

int foo(int param1, int param2)
{
	int sum = param1 + param2;
	return sum;
}

int bar(int count)
{
	int i;
	int j;
	int k;

	for (i = 0; i < 6; i++)
	{
		if (i <= 4)
		{
			j = i * 2;
			j++;
		}
		else
		{
			k = i * 100 / 3;
			k = k + 10;
		}
	}

	return (i + j + k);
}
