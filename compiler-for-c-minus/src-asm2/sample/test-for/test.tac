
	function fib
fib:
	beginfunc
	int_param n
	int i
	int prev1
	int prev2
	int res
	int T0
	T0 = n <= 0
	ifnz T0 goto L0
	goto L1
L0:
	return 0
L1:
	int T1
	T1 = n <= 2
	ifnz T1 goto L5
	goto L6
L5:
	return 1
	goto L7
L6:
	prev1 = 1
	prev2 = 1
	i = 3
L2:
	int T2
	T2 = i <= n
	ifnz T2 goto L3
	goto L4
L3:
	int T4
	T4 = prev1 + prev2
	res = T4
	prev1 = prev2
	prev2 = res
	int T3
	T3 = i + 1
	i = T3
	goto L2
L4:
L7:
	return res
	endfunc
