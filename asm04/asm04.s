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

    cmp rcx, 1
    je exit_bad_input

    test rax, 1
    jnz exit_odd

exit_even:
    mov rax, 60
    xor rdi, rdi
    syscall

exit_odd:
    mov rax, 60
    mov rdi, 1
    syscall

exit_bad_input:
    mov rax, 60
    mov rdi, 2
    syscall

ascii_to_int:
    xor rax, rax
    xor rbx, rbx
    xor rcx, rcx
.loop:
    mov bl, [rsi]
    cmp bl, 10
    je .done
    cmp bl, 0
    je .done

    cmp bl, '0'
    jl .error
    cmp bl, '9'
    jg .error

    sub bl, '0'
    imul rax, 10
    add rax, rbx
    inc rsi
    jmp .loop

.error:
    mov rcx, 1
.done:
    ret
