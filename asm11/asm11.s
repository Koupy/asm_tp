section .bss
    buffer resb 32

section .data
    nl db 10
    ten dq 10

section .text
    global _start

_start:
    cmp qword [rsp], 2
    jne fail_exit

    mov rsi, [rsp+16]
    call str_to_int

    call factorial

    mov rdi, buffer
    call int_to_str

    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

fail_exit:
    mov rax, 60
    mov rdi, 1
    syscall

str_to_int:
    xor rax, rax
.next_char:
    movzx rdx, byte [rsi]
    cmp dl, 0
    je .done
    sub dl, '0'
    imul rax, rax, 10
    add rax, rdx
    inc rsi
    jmp .next_char
.done:
    ret

factorial:
    cmp rax, 0
    je .zero
    cmp rax, 1
    je .one
    
    mov rbx, rax
    mov rcx, 1
    
.loop:
    imul rcx, rbx
    dec rbx
    cmp rbx, 1
    jg .loop
    
    mov rax, rcx
    ret
    
.zero:
.one:
    mov rax, 1
    ret

int_to_str:
    mov r8, rdi
    add rdi, 31
    mov byte [rdi], 0
    dec rdi
.loop:
    xor rdx, rdx
    div qword [ten]
    add dl, '0'
    mov [rdi], dl
    dec rdi
    test rax, rax
    jnz .loop
    inc rdi
    mov rsi, rdi
    mov rdi, r8
    mov rcx, 32
    rep movsb
    mov rax, rsi
    sub rax, r8
    ret
