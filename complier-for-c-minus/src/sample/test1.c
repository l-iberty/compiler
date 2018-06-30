int foo(int a, int b)
{
	int array[10];
	int i, j, temp, sum;
	
	temp = 10;
	i = 0;
	sum = 0;
	
	while (i < temp)
	{
		array[i] = temp + i;
		sum += array[i];
		if (sum >= 50)
		{
			sum -= 50;
		}
		else
		{
			j = sum;
			break;
		}
	}
	
	return (j * sum);
}

int bar()
{
	int retval;
	retval = foo(12, 14);
	return retval;
}

int foobar()
{
	return bar();
}
