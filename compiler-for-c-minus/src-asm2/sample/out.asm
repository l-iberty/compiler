[section .data]


global gi:data
gi  dd  0

[section .text]

global foo:function

foo:
	push ebp
	mov ebp, esp
	sub esp, 0x00000048
	mov eax, 0x0000000A
	mov [ebp + 0xFFFFFFFC], eax
	mov eax, 0x00000032
	mov [ebp + 0xFFFFFFF8], eax
	mov eax, [ebp + 0xFFFFFFFC]
	mov edx, [ebp + 0xFFFFFFF8]
	sub eax, edx
	mov [ebp + 0xFFFFFFF4], eax
	mov eax, [ebp + 0xFFFFFFF4]
	mov [ebp + 0x00000008], eax
	mov eax, [ebp + 0xFFFFFFF8]
	mov edx, [ebp + 0xFFFFFFFC]
	sub eax, edx
	mov [ebp + 0xFFFFFFF0], eax
	mov eax, [ebp + 0xFFFFFFF0]
	mov [ebp + 0x0000000C], eax
	mov eax, 0x0000000A
	imul eax, [ebp + 0x0000000C]
	mov [ebp + 0xFFFFFFEC], eax
	mov eax, [ebp + 0xFFFFFFFC]
	mov edx, [ebp + 0xFFFFFFEC]
	add eax, edx
	mov [ebp + 0xFFFFFFE8], eax
	mov eax, [ebp + 0x00000008]
	mov edx, [ebp + 0xFFFFFFE8]
	sub eax, edx
	mov [ebp + 0xFFFFFFE4], eax
	mov eax, [ebp + 0xFFFFFFE4]
	mov [ebp + 0x00000010], eax
	mov eax, 0x00000004
	imul eax, [ebp + 0x0000000C]
	mov [ebp + 0xFFFFFFE0], eax
	mov eax, [ebp + 0x00000008]
	mov edx, [ebp + 0xFFFFFFE0]
	add eax, edx
	mov [ebp + 0xFFFFFFDC], eax
	mov eax, [ebp + 0xFFFFFFF8]
	mov ecx, 0x00000002
	cdq
	idiv ecx
	mov [ebp + 0xFFFFFFD8], eax
	mov eax, [ebp + 0xFFFFFFDC]
	mov edx, [ebp + 0xFFFFFFD8]
	sub eax, edx
	mov [ebp + 0xFFFFFFD4], eax
	mov eax, [ebp + 0xFFFFFFD4]
	mov edx, [ebp + 0x00000010]
	sub eax, edx
	mov [ebp + 0xFFFFFFD0], eax
	mov eax, [ebp + 0xFFFFFFD0]
	mov [ebp + 0xFFFFFFFC], eax
	mov eax, [ebp + 0xFFFFFFFC]
	mov [gi], eax
	mov eax, [ebp + 0xFFFFFFFC]
	mov edx, 0x000000C8
	cmp eax, edx
	jl .cmp0
	mov eax, 0
	jmp .cmp1
.cmp0:
	mov eax, 1
.cmp1:
	mov [ebp + 0xFFFFFFCC], eax
	mov eax, [ebp + 0xFFFFFFCC]
	jmp endfunc1
endfunc1:
	mov esp, ebp
	pop ebp
	ret

global bar:function

bar:
	push ebp
	mov ebp, esp
	sub esp, 0x00000028
	mov eax, 0x00000004
	imul eax, 0x00000004
	mov [ebp + 0xFFFFFFF4], eax
	mov eax, [ebp + 0xFFFFFFF4]
	add eax, 0x0000000A
	mov [ebp + 0xFFFFFFF0], eax
	mov eax, [ebp + 0xFFFFFFFC]
	mov edx, [ebp + 0xFFFFFFF8]
	add eax, edx
	mov [ebp + 0xFFFFFFEC], eax
	push 0x00000064
	mov eax, [ebp + 0xFFFFFFF0]
	push eax
	mov eax, [ebp + 0xFFFFFFEC]
	push eax
	call foo
	add esp, 0x0000000c
	mov [ebp + 0xFFFFFFE8], eax
	mov eax, 0x00000014
	neg eax
	mov [ebp + 0xFFFFFFE4], eax
	mov eax, [ebp + 0xFFFFFFE8]
	mov edx, [ebp + 0xFFFFFFE4]
	add eax, edx
	mov [ebp + 0xFFFFFFE0], eax
	mov eax, [ebp + 0xFFFFFFE0]
	jmp endfunc2
endfunc2:
	mov esp, ebp
	pop ebp
	ret

global fact:function

fact:
	push ebp
	mov ebp, esp
	sub esp, 0x00000020
	mov eax, [ebp + 0x00000008]
	mov edx, 0x00000000
	cmp eax, edx
	je .cmp2
	mov eax, 0
	jmp .cmp3
.cmp2:
	mov eax, 1
.cmp3:
	mov [ebp + 0xFFFFFFFC], eax
	mov eax, [ebp + 0xFFFFFFFC]
	cmp eax, 0
	jnz L0
	jmp L1

L0:
	mov eax, 0x00000001
	jmp endfunc3
	jmp L2

L1:
	mov eax, [ebp + 0x00000008]
	sub eax, 0x00000001
	mov [ebp + 0xFFFFFFF8], eax
	mov eax, [ebp + 0xFFFFFFF8]
	push eax
	call fact
	add esp, 0x00000004
	mov [ebp + 0xFFFFFFF4], eax
	mov eax, [ebp + 0x00000008]
	imul eax, [ebp + 0xFFFFFFF4]
	mov [ebp + 0xFFFFFFF0], eax
	mov eax, [ebp + 0xFFFFFFF0]
	jmp endfunc3

L2:
endfunc3:
	mov esp, ebp
	pop ebp
	ret

global fib:function

fib:
	push ebp
	mov ebp, esp
	sub esp, 0x00000040
	mov eax, [ebp + 0x00000008]
	mov edx, 0x00000000
	cmp eax, edx
	jle .cmp4
	mov eax, 0
	jmp .cmp5
.cmp4:
	mov eax, 1
.cmp5:
	mov [ebp + 0xFFFFFFEC], eax
	mov eax, [ebp + 0xFFFFFFEC]
	cmp eax, 0
	jnz L3
	jmp L4

L3:
	mov eax, 0x00000000
	jmp endfunc4

L4:
	mov eax, [ebp + 0x00000008]
	mov edx, 0x00000002
	cmp eax, edx
	jle .cmp6
	mov eax, 0
	jmp .cmp7
.cmp6:
	mov eax, 1
.cmp7:
	mov [ebp + 0xFFFFFFE8], eax
	mov eax, [ebp + 0xFFFFFFE8]
	cmp eax, 0
	jnz L8
	jmp L9

L8:
	mov eax, 0x00000001
	jmp endfunc4
	jmp L10

L9:
	mov eax, 0x00000001
	mov [ebp + 0xFFFFFFF0], eax
	mov eax, 0x00000001
	mov [ebp + 0xFFFFFFFC], eax
	mov eax, 0x00000001
	mov [ebp + 0xFFFFFFF8], eax

L5:
	mov eax, [ebp + 0xFFFFFFF0]
	mov edx, [ebp + 0x00000008]
	cmp eax, edx
	jl .cmp8
	mov eax, 0
	jmp .cmp9
.cmp8:
	mov eax, 1
.cmp9:
	mov [ebp + 0xFFFFFFE4], eax
	mov eax, [ebp + 0xFFFFFFE4]
	cmp eax, 0
	jnz L6
	jmp L7

L6:
	mov eax, [ebp + 0xFFFFFFFC]
	mov edx, [ebp + 0xFFFFFFF8]
	add eax, edx
	mov [ebp + 0xFFFFFFE0], eax
	mov eax, [ebp + 0xFFFFFFE0]
	mov [ebp + 0xFFFFFFF4], eax
	mov eax, [ebp + 0xFFFFFFF8]
	mov [ebp + 0xFFFFFFFC], eax
	mov eax, [ebp + 0xFFFFFFF4]
	mov [ebp + 0xFFFFFFF8], eax
	mov eax, [ebp + 0xFFFFFFF0]
	add eax, 0x00000001
	mov [ebp + 0xFFFFFFDC], eax
	mov eax, [ebp + 0xFFFFFFDC]
	mov [ebp + 0xFFFFFFF0], eax
	jmp L5

L7:

L10:
	mov eax, [ebp + 0xFFFFFFF4]
	jmp endfunc4
endfunc4:
	mov esp, ebp
	pop ebp
	ret
