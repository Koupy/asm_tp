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
    
    test rax, rax
    js exit_not_prime

    call is_prime
    cmp rax, 1
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
    xor rdx, rdx
    
    cmp byte [rsi], '-'
    jne .loop
    mov rdx, 1
    inc rsi
    
.loop:
    mov bl, [rsi]
    cmp bl, 10
    je .done
    cmp bl, 0
    je .done
    cmp bl, '0'
    jb .invalid
    cmp bl, '9'
    ja .invalid
    sub bl, '0'
    imul rax, 10
    add rax, rbx
    inc rsi
    jmp .loop
.done:
    test rdx, rdx
    jz .positive
    neg rax
.positive:
    ret
.invalid:
    mov rax, 60
    mov rdi, 2
    syscall

is_prime:
    cmp rax, 2
    jb .not_prime
    cmp rax, 2
    je .prime
    
    mov rbx, rax
    mov rcx, 2
    
.check_loop:
    mov rax, rbx
    xor rdx, rdx
    div rcx
    cmp rdx, 0
    je .not_prime
    
    inc rcx
    mov rax, rcx
    imul rax, rax
    cmp rax, rbx
    jbe .check_loop
    
.prime:
    mov rax, 1
    ret
.not_prime:
    xor rax, rax
    ret
