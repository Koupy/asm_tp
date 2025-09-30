section .bss
    buffer resb 32

section .data
    nl db 10
    ten dq 10

section .text
    global _start

_start:
    cmp qword [rsp], 4
    jne exit_failure

    mov rsi, [rsp+16]
    call ascii_to_int
    mov r12, rax

    mov rsi, [rsp+24]
    call ascii_to_int
    cmp r12, rax
    jge .skip1
    mov r12, rax
.skip1:

    mov rsi, [rsp+32]
    call ascii_to_int
    cmp r12, rax
    jge .skip2
    mov r12, rax
.skip2:

    mov rax, r12
    mov rdi, buffer
    call int_to_ascii

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
    xor r10, r10
    
    cmp byte [rsi], '-'
    jne .loop
    mov r10, 1
    inc rsi
    
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
    test r10, r10
    jz .positive
    neg rax
.positive:
    ret

int_to_ascii:
    mov r8, rdi
    mov r11, 0
    
    test rax, rax
    jns .convert
    neg rax
    mov r11, 1
    
.convert:
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

    cmp r11, 1
    jne .copy
    mov byte [rdi], '-'
    dec rdi

.copy:
    inc rdi
    mov rdx, r8
    add rdx, 32
    sub rdx, rdi
    mov rax, rdx

    mov rcx, rax
    mov rsi, rdi
    mov rdi, r8
    rep movsb
    ret
