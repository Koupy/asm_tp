section .bss
    buffer resb 256

section .data
    nl db 10

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 256
    syscall

    mov rdi, buffer
    call length

    mov rcx, rax
    dec rcx
    mov rsi, buffer
    mov rdi, buffer
    add rdi, rcx

.reverse_loop:
    cmp rsi, rdi
    jge .done_reverse
    
    mov al, [rsi]
    mov bl, [rdi]
    mov [rsi], bl
    mov [rdi], al
    
    inc rsi
    dec rdi
    jmp .reverse_loop

.done_reverse:
    mov rdi, buffer
    call length
    
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

length:
    xor rax, rax
.loop:
    cmp byte [rdi+rax], 10
    je .done
    cmp byte [rdi+rax], 0
    je .done
    inc rax
    jmp .loop
.done:
    ret
