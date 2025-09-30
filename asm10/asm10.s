section .bss
    buffer resb 32

section .data
    nl db 10
    ten dq 10

section .text
    global _start

_start:
    cmp qword [rsp], 2
    jne fail_exit

    mov rsi, [rsp+16]
    call str_to_int
    mov r15, rax

    mov r14, 2

.loop_numbers:
    cmp r14, r15
    jg exit_success

    mov rax, r14
    call is_prime
    test rax, rax
    jz .next_number

    mov rax, r14
    mov rdi, buffer
    call int_to_str

    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall

.next_number:
    inc r14
    jmp .loop_numbers

exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall

fail_exit:
    mov rax, 60
    mov rdi, 1
    syscall

str_to_int:
    xor rax, rax
.next_char:
    movzx rdx, byte [rsi]
    cmp dl, 0
    je .done
    sub dl, '0'
    imul rax, rax, 10
    add rax, rdx
    inc rsi
    jmp .next_char
.done:
    ret

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
    test rdx, rdx
    jz .not_prime
    
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

int_to_str:
    mov r8, rdi
    add rdi, 31
    mov byte [rdi], 0
    dec rdi
.loop:
    xor rdx, rdx
    div qword [ten]
    add dl, '0'
    mov [rdi], dl
    dec rdi
    test rax, rax
    jnz .loop
    inc rdi
    mov rsi, rdi
    mov rdi, r8
    mov rcx, 32
    rep movsb
    mov rax, rsi
    sub rax, r8
    ret
