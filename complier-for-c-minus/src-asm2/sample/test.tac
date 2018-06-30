	int gi

	function foo
foo:
	beginfunc
	int_param a
	int_param b
	int_param c
	int i
	int j
	i = 10
	j = 50
	int T0
	T0 = i - j
	a = T0
	int T1
	T1 = j - i
	b = T1
	int T2
	T2 = 10 * b
	int T3
	T3 = i + T2
	int T4
	T4 = a - T3
	c = T4
	int T5
	T5 = b * 4
	int T6
	T6 = a + T5
	int T7
	T7 = j / 2
	int T8
	T8 = T6 - T7
	int T9
	T9 = T8 - c
	i = T9
	gi = i
	int T10
	T10 = i < 200
	return T10
	endfunc

	function bar
bar:
	beginfunc
	int a
	int b
	arg 100
	int T12
	T12 = 4 * 5
	int T13
	T13 = 10 + T12
	arg T13
	int T11
	T11 = a + b
	arg T11
	int T14
	T14 = call foo
	int T15
	T15 = - 20
	int T16
	T16 = T14 + T15
	return T16
	endfunc

	function fact
fact:
	beginfunc
	int_param n
	int T17
	T17 = n == 0
	ifnz T17 goto L0
	goto L1
L0:
	return 1
	goto L2
L1:
	int T18
	T18 = n - 1
	arg T18
	int T19
	T19 = call fact
	int T20
	T20 = n * T19
	return T20
L2:
	endfunc

	function fib
fib:
	beginfunc
	int_param n
	int prev1
	int prev2
	int res
	int i
	int T21
	T21 = n <= 0
	ifnz T21 goto L3
	goto L4
L3:
	return 0
L4:
	int T22
	T22 = n <= 2
	ifnz T22 goto L8
	goto L9
L8:
	return 1
	goto L10
L9:
	i = 1
	prev1 = 1
	prev2 = 1
L5:
	int T23
	T23 = i < n
	ifnz T23 goto L6
	goto L7
L6:
	int T24
	T24 = prev1 + prev2
	res = T24
	prev1 = prev2
	prev2 = res
	int T25
	T25 = i + 1
	i = T25
	goto L5
L7:
L10:
	return res
	endfunc
