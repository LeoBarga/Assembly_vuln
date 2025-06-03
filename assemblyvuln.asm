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

fine:
    ; se il programma finisse normalmente
    mov eax, 1        ;
    xor ebx, ebx      ; exit code = 0
    int 0x80

uscita:
    mov ex, 1
    xor ebx, ebx
    int 0x80

SECTION .data
msg db "Overflow riuscito!\n", 0x0
msglen equ $ - msg