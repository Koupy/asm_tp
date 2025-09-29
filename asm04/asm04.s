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

ascii_to_int:
    xor rax, rax
    xor rbx, rbx
.loop:
    mov bl, [rsi]
    cmp bl, 10
    je .done
    cmp bl, '0'
    jl .done
    cmp bl, '9'
    jg .done

    sub bl, '0'
    imul rax, 10
    add rax, rbx
    inc rsi
    jmp .loop
.done:
    ret
