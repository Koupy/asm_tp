section .data
    arg db "42", 0
    msg db "1337", 10
    len equ $ - msg

section .text
    global _start

_start:
    mov rsi, [rsp+16]
    cmp byte [rsp], 2
    jne exit_failure

    mov rdi, arg
    call compare
    cmp rax, 0
    jne exit_failure

    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, len
    syscall

exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall

exit_failure:
    mov rax, 60
    mov rdi, 1
    syscall

compare:
    push rsi
    push rdi
.loop:
    mov al, [rdi]
    mov ah, [rsi]
    cmp al, ah
    jne .notequal
    cmp al, 0
    je .equal
    inc rsi
    inc rdi
    jmp .loop
.equal:
    pop rdi
    pop rsi
    xor rax, rax
    ret
.notequal:
    pop rdi
    pop rsi
    mov rax, 1
    ret
