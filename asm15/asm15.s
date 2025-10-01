section .bss
    file resb 5

section .data
    elf db 0x7f, "ELF"

section .text
    global _start

_start:
    cmp byte [rsp], 2
    jne exit_failure

    mov rax, 2
    mov rdi, [rsp+16]
    xor rsi, rsi
    syscall

    cmp rax, 0
    jl exit_failure
    mov r12, rax

    mov rax, 0
    mov rdi, r12
    mov rsi, file
    mov rdx, 5
    syscall

    mov rax, 3
    mov rdi, r12
    syscall

    mov rsi, file
    mov rdi, elf
    mov rcx, 4
    repe cmpsb
    jne exit_failure

    cmp byte [file+4], 2
    jne exit_failure

exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall

exit_failure:
    mov rax, 60
    mov rdi, 1
    syscall
