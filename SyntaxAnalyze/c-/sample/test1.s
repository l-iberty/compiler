	.file	"test1.c"
	.text
	.globl	foo
	.type	foo, @function
foo:
.LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$72, %esp
	movl	%gs:20, %eax
	movl	%eax, -12(%ebp)
	xorl	%eax, %eax
	movl	$10, -60(%ebp)
	movl	$0, -56(%ebp)
	movl	$0, -64(%ebp)
	jmp	.L2
.L4:
	movl	-60(%ebp), %edx
	movl	-56(%ebp), %eax
	addl	%eax, %edx
	movl	-56(%ebp), %eax
	movl	%edx, -52(%ebp,%eax,4)
	movl	-56(%ebp), %eax
	movl	-52(%ebp,%eax,4), %eax
	addl	%eax, -64(%ebp)
	cmpl	$49, -64(%ebp)
	jle	.L3
	subl	$50, -64(%ebp)
	jmp	.L2
.L3:
	movl	-64(%ebp), %eax
	movl	%eax, -68(%ebp)
.L2:
	movl	-56(%ebp), %eax
	cmpl	-60(%ebp), %eax
	jl	.L4
	movl	-68(%ebp), %eax
	imull	-64(%ebp), %eax
	movl	-12(%ebp), %ecx
	xorl	%gs:20, %ecx
	je	.L6
	call	__stack_chk_fail
.L6:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	foo, .-foo
	.globl	bar
	.type	bar, @function
bar:
.LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	subl	$8, %esp
	pushl	$14
	pushl	$12
	call	foo
	addl	$16, %esp
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	bar, .-bar
	.globl	foobar
	.type	foobar, @function
foobar:
.LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	call	bar
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	foobar, .-foobar
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.4) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
