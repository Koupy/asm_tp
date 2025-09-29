section .data
    input db "42"
    msg db "1337", 10
    msg_len equ $ - msg

section .bss
    buffer resb 4

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 4
    syscall

    mov rsi, buffer
    mov rdi, input
    mov rcx, 2
    repe cmpsb
    jne exit_failure

    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall

exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall

exit_failure:
    mov rax, 60
    mov rdi, 1
    syscall
