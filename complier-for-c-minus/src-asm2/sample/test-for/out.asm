[section .data]


[section .text]

global fib:function

fib:
	push ebp
	mov ebp, esp
	sub esp, 0x00000040
	mov eax, [ebp + 0x00000008]
	mov edx, 0x00000000
	cmp eax, edx
	jle .cmp0
	mov eax, 0
	jmp .cmp1
.cmp0:
	mov eax, 1
.cmp1:
	mov [ebp + 0xFFFFFFEC], eax
	mov eax, [ebp + 0xFFFFFFEC]
	cmp eax, 0
	jnz L0
	jmp L1

L0:
	mov eax, 0x00000000
	jmp endfunc1

L1:
	mov eax, [ebp + 0x00000008]
	mov edx, 0x00000002
	cmp eax, edx
	jle .cmp2
	mov eax, 0
	jmp .cmp3
.cmp2:
	mov eax, 1
.cmp3:
	mov [ebp + 0xFFFFFFE8], eax
	mov eax, [ebp + 0xFFFFFFE8]
	cmp eax, 0
	jnz L5
	jmp L6

L5:
	mov eax, 0x00000001
	jmp endfunc1
	jmp L7

L6:
	mov eax, 0x00000001
	mov [ebp + 0xFFFFFFF8], eax
	mov eax, 0x00000001
	mov [ebp + 0xFFFFFFF4], eax
	mov eax, 0x00000003
	mov [ebp + 0xFFFFFFFC], eax

L2:
	mov eax, [ebp + 0xFFFFFFFC]
	mov edx, [ebp + 0x00000008]
	cmp eax, edx
	jle .cmp4
	mov eax, 0
	jmp .cmp5
.cmp4:
	mov eax, 1
.cmp5:
	mov [ebp + 0xFFFFFFE4], eax
	mov eax, [ebp + 0xFFFFFFE4]
	cmp eax, 0
	jnz L3
	jmp L4

L3:
	mov eax, [ebp + 0xFFFFFFF8]
	mov edx, [ebp + 0xFFFFFFF4]
	add eax, edx
	mov [ebp + 0xFFFFFFE0], eax
	mov eax, [ebp + 0xFFFFFFE0]
	mov [ebp + 0xFFFFFFF0], eax
	mov eax, [ebp + 0xFFFFFFF4]
	mov [ebp + 0xFFFFFFF8], eax
	mov eax, [ebp + 0xFFFFFFF0]
	mov [ebp + 0xFFFFFFF4], eax
	mov eax, [ebp + 0xFFFFFFFC]
	add eax, 0x00000001
	mov [ebp + 0xFFFFFFDC], eax
	mov eax, [ebp + 0xFFFFFFDC]
	mov [ebp + 0xFFFFFFFC], eax
	jmp L2

L4:

L7:
	mov eax, [ebp + 0xFFFFFFF0]
	jmp endfunc1
endfunc1:
	mov esp, ebp
	pop ebp
	ret
