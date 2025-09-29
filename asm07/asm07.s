section .bss
    buffer resb 16

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 16
    syscall

    mov rsi, buffer
    call ascii_to_int

    call is_prime
    cmp rax, 0
    je exit_prime

exit_not_prime:
    mov rax, 60
    mov rdi, 1
    syscall

exit_prime:
    mov rax, 60
    xor rdi, rdi
    syscall

ascii_to_int:
    xor rax, rax
    xor rbx, rbx
.loop:
    mov bl, [rsi]
    cmp bl, 10
    je .done
    sub bl, '0'
    imul rax, 10
    add rax, rbx
    inc rsi
    jmp .loop
.done:
    ret

is_prime:
    cmp rax, 2
    jl .not_prime
    cmp rax, 2
    je .prime
    cmp rax, 3
    je .prime
    
    test rax, 1
    jz .not_prime
    
    mov r12, rax
    mov r13, 3
    
.test_loop:
    mov rax, r12
    shr rax, 1
    cmp r13, rax
    jg .prime
    
    mov rax, r12
    xor rdx, rdx
    div r13
    cmp rdx, 0
    je .not_prime
    
    add r13, 2
    jmp .test_loop

.prime:
    mov rax, 1
    ret
.not_prime:
    xor rax, rax
    ret
