int foo()
{
	int i, j, k, r, s;
	i = 0;
	j = 10;
	r = i < j;
	s = i <= j;
	r = 10 != i;
	s = j == 10;

	i = i * 4 < 2;
	j = j == s + r;

	return j;
}
