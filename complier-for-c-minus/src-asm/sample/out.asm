[section .data]


global gi:data
gi  dd  0

[section .text]

L10:

global foo:function

foo:
	push ebp
	mov ebp, esp
	sub esp, 0x00000048
	mov eax, 0x0000000A
	mov [ebp + 0xFFFFFFF8], eax
	mov eax, 0x00000032
	mov [ebp + 0xFFFFFFFC], eax
	mov eax, [ebp + 0xFFFFFFF8]
	mov edx, [ebp + 0xFFFFFFFC]
	sub eax, edx
	mov [ebp + 0xFFFFFFF4], eax
	mov eax, [ebp + 0xFFFFFFF4]
	mov [ebp + 0x00000008], eax
	mov eax, [ebp + 0xFFFFFFFC]
	mov edx, [ebp + 0xFFFFFFF8]
	sub eax, edx
	mov [ebp + 0xFFFFFFF0], eax
	mov eax, [ebp + 0xFFFFFFF0]
	mov [ebp + 0x0000000C], eax
	mov eax, 0x0000000A
	imul eax, [ebp + 0x0000000C]
	mov [ebp + 0xFFFFFFEC], eax
	mov eax, [ebp + 0xFFFFFFF8]
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
	mov eax, [ebp + 0xFFFFFFFC]
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
	mov [ebp + 0xFFFFFFF8], eax
	mov eax, [ebp + 0xFFFFFFF8]
	mov [gi], eax
	mov eax, [ebp + 0xFFFFFFF8]
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

L11:

global bar:function

bar:
	push ebp
	mov ebp, esp
	sub esp, 0x0000001C
	mov eax, [ebp + 0xFFFFFFF8]
	mov edx, [ebp + 0xFFFFFFFC]
	add eax, edx
	mov [ebp + 0xFFFFFFF0], eax
	push 0x00000064
	push 0x0000001E
	mov eax, [ebp + 0xFFFFFFF0]
	push eax
	call L10
	add esp, 0x0000000c
	mov [ebp + 0xFFFFFFF4], eax
	mov eax, 0x00000014
	neg eax
	mov [ebp + 0xFFFFFFEC], eax
	mov eax, [ebp + 0xFFFFFFEC]
	jmp endfunc2
endfunc2:
	mov esp, ebp
	pop ebp
	ret

L14:

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
	jz L12
	mov eax, 0x00000001
	jmp endfunc3
	jmp L13

L12:
	mov eax, [ebp + 0x00000008]
	sub eax, 0x00000001
	mov [ebp + 0xFFFFFFF4], eax
	mov eax, [ebp + 0xFFFFFFF4]
	push eax
	call L14
	add esp, 0x00000004
	mov [ebp + 0xFFFFFFF8], eax
	mov eax, [ebp + 0x00000008]
	imul eax, [ebp + 0xFFFFFFF8]
	mov [ebp + 0xFFFFFFF0], eax
	mov eax, [ebp + 0xFFFFFFF0]
	jmp endfunc3

L13:
endfunc3:
	mov esp, ebp
	pop ebp
	ret

L20:

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
	jz L15
	mov eax, 0x00000000
	jmp endfunc4

L15:
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
	jz L18
	mov eax, 0x00000001
	jmp endfunc4
	jmp L19

L18:
	mov eax, 0x00000001
	mov [ebp + 0xFFFFFFF0], eax
	mov eax, 0x00000001
	mov [ebp + 0xFFFFFFF4], eax
	mov eax, 0x00000001
	mov [ebp + 0xFFFFFFF8], eax

L16:
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
	jz L17
	mov eax, [ebp + 0xFFFFFFF4]
	mov edx, [ebp + 0xFFFFFFF8]
	add eax, edx
	mov [ebp + 0xFFFFFFE0], eax
	mov eax, [ebp + 0xFFFFFFE0]
	mov [ebp + 0xFFFFFFFC], eax
	mov eax, [ebp + 0xFFFFFFF8]
	mov [ebp + 0xFFFFFFF4], eax
	mov eax, [ebp + 0xFFFFFFFC]
	mov [ebp + 0xFFFFFFF8], eax
	mov eax, [ebp + 0xFFFFFFF0]
	add eax, 0x00000001
	mov [ebp + 0xFFFFFFDC], eax
	mov eax, [ebp + 0xFFFFFFDC]
	mov [ebp + 0xFFFFFFF0], eax
	jmp L16

L17:

L19:
	mov eax, [ebp + 0xFFFFFFFC]
	jmp endfunc4
endfunc4:
	mov esp, ebp
	pop ebp
	ret
