; octet_index: Offset from 4 byte octet array
; current_octet: Sum of digits in current octet
; i: Offset in string
; r12 will hold the string address

global ip_to_bin

section .text
ip_to_bin:
    lea r12, [rdi] ; String with IP address
    xor rcx, rcx   ; i
    xor rbx, rbx   ; octet_index
    xor rdx, rdx   ; current_octet

.loop:
    mov al, byte [r12+rcx]
    cmp al, 0
    je .exit_loop

    cmp al, '.'
    je .transfer_octet

    sub al, '0'
    imul rdx, 10
    movzx rax, al
    add rdx, rax

    inc rcx
    jmp .loop

.transfer_octet:
    mov [octets+rbx], dl  ; Move current octet's sum into it's place in the array
    inc rbx               ; octet_index++
    xor rdx, rdx          ; current_octet sum reset for next octet
    inc rcx
    jmp .loop


.exit_loop:
    mov [octets+rbx], dl
    xor eax, eax
    mov al, byte [octets+3]
    shl eax, 8
    mov al, byte [octets+2]
    shl eax, 8
    mov al, byte [octets+1]
    shl eax, 8
    mov al, byte [octets]

    ret

section .bss
octets: resb 4
