section .data
    message db "1337", 10
    msg_len equ $ - message

section .text
    global _start

_start:
    mov rax, 1          
    mov rdi, 1          
    mov rsi, message    
    mov rdx, msg_len    
    syscall             

    mov rax, 60         
    xor rdi, rdi        
    syscall
