section .bss
    buffer resb 1024

section .data
    line db 10

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 1024
    syscall

    mov r12, rax
    dec r12

    mov rsi, buffer
    mov rdi, buffer
    add rdi, r12
    dec rdi

.swap_loop:
    cmp rsi, rdi
    jge .end_swap

    mov al, [rsi]
    mov bl, [rdi]
    mov [rsi], bl
    mov [rdi], al

    inc rsi
    dec rdi
    jmp .swap_loop

.end_swap:
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, r12
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, line
    mov rdx, 1
    syscall

exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall
