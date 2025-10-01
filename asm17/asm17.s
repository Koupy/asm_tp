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
    mov r15, buffer
    add r15, r13
.cipher_loop:
    cmp r14, r15
    jge .endcipher

    mov r15b, [r14]

    cmp r15b, 'a'
    jl .nextchar
    cmp r15b, 'z'
    jg .nextchar

    add r15b, r12b
    cmp r15b, 'z'
    jle .char
    sub r15b, 26

.char:
    mov [r14], r15b

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
