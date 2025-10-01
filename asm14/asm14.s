section .data
    msg db "Hello Universe!", 10
    len equ $ - msg

section .text
    global _start

_start:
    cmp byte [rsp], 2
    jne exit_failure

    mov rax, 2
    mov rdi, [rsp+16]
    mov rsi, 65
    mov rdx, 0644o
    syscall

    cmp rax, 0
    jl exit_failure

    mov r12, rax

    mov rax, 1
    mov rdi, r12
    mov rsi, msg
    mov rdx, len
    syscall

    mov rax, 3
    mov rdi, r12
    syscall

exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall

exit_failure:
    mov rax, 60
    mov rdi, 1
    syscall
