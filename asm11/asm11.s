section .bss
    input resb 65536
    result resb 32

section .data
    vowels db "aeiouyAEIOUY"
    nl db 10
    ten dq 10

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 65536
    syscall

    mov r11, rax
    mov r12, 0
    mov r13, input
    mov r10, 0
.char_loop:
    cmp r10, r11
    jge .end_count
    mov r14b, [r13]
    cmp r14b, 10
    je .end_count
    cmp r14b, 0
    je .end_count

    mov r15, 0
.vowel_loop:
    cmp r15, 12
    je .next_char
    mov bl, [vowels+r15]
    cmp r14b, bl
    je .found_vowel
    inc r15
    jmp .vowel_loop

.found_vowel:
    inc r12

.next_char:
    inc r13
    inc r10
    jmp .char_loop

.end_count:
    mov rax, r12
    mov rdi, result
    call int_to_str

    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, result
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

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
