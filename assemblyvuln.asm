BITS 32
GLOBAL _start

SECTION .text

_start:
    call my_function     ; chiama la funzione vulnerabile
    jmp fine             ; salta la fine

my_function:
    push ebp
    mov ebp, esp
    sub ep, 16          ; alloca un buffer da 16 byte nello stack

; syscall read: legge 64 byte (OVERFLOW)
    mov eax, 3
    mov ebx, 0
    lea ecx, [ebp-16]    ; indirizzo del buffer nello stack
    mov edx, 64          ; legge fino a 64 byte (OVERFLOW)
    int 0x80

    ; termina la funzione
    mov esp, ebp
    pop ebp
    ret