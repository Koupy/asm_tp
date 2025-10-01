section .bss
    buffer resb 1024

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 1024
    syscall

    mov r12, rax
    test r12, r12
    jz palindrome
    
    dec r12
.remove_newlines:
    cmp r12, 0
    jl palindrome
    mov al, [buffer+r12]
    cmp al, 10
    je .dec_and_continue
    cmp al, 13
    je .dec_and_continue
    jmp .start_check
.dec_and_continue:
    dec r12
    jmp .remove_newlines

.start_check:
    mov rsi, buffer
    mov rdi, buffer
    add rdi, r12

.check_loop:
    cmp rsi, rdi
    jge palindrome

    mov al, [rsi]
    mov bl, [rdi]
    cmp al, bl
    jne not_palindrome

    inc rsi
    dec rdi
    jmp .check_loop

palindrome:
    mov rax, 60
    xor rdi, rdi
    syscall

not_palindrome:
    mov rax, 60
    mov rdi, 1
    syscall
