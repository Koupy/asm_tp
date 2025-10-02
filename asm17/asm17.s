section .bss
    buffer resb 1024

section .data
    line db 10

section .text
    global _start

_start:
    cmp byte [rsp], 2
    jne exit_failure

    mov rsi, [rsp+16]
    call ascii_to_int
    mov r12, rax

    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 1024
    syscall
    mov r13, rax

    mov r14, buffer
    lea r15, [buffer + r13]
.cipher_loop:
    cmp r14, r15
    jge .endcipher

    movzx rax, byte [r14]

    cmp al, 'a'
    jl .check_upper
    cmp al, 'z'
    jg .check_upper

    add al, r12b
    cmp al, 'z'
    jle .char
    sub al, 26
    jmp .char

.check_upper:
    cmp al, 'A'
    jl .nextchar
    cmp al, 'Z'
    jg .nextchar

    add al, r12b
    cmp al, 'Z'
    jle .char
    sub al, 26

.char:
    mov [r14], al

.nextchar:
    inc r14
    jmp .cipher_loop

.endcipher:
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, r13
    syscall

exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall

exit_failure:
    mov rax, 60
    mov rdi, 1
    syscall

ascii_to_int:
    xor rax, rax
    xor rbx, rbx
.loop:
    mov bl, [rsi]
    cmp bl, 0
    je .done
    sub bl, '0'
    imul rax, 10
    add rax, rbx
    inc rsi
    jmp .loop
.done:
    ret

    ret
