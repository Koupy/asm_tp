section .data
    line db 10

section .text
    global _start

_start:
    cmp byte [rsp], 2
    jne exit_failure

    mov rsi, [rsp+16]

    mov rdi, rsi
    call length
    mov rdx, rax

    mov rax, 1
    mov rdi, 1
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

exit_failure:
    mov rax, 60
    mov rdi, 1
    syscall

length:
    xor rax, rax
.loop:
    cmp byte [rdi+rax], 0
    je .done
    inc rax
    jmp .loop
.done:
    ret
