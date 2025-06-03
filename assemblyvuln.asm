BITS 32
GLOBAL _start

SECTION .data
msg db "Funzione terminata", 0xA
msglen equ $ - msg

SECTION .text