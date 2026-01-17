[BITS 16]
[ORG 0x7E00]

main:
    xor ax, ax
    mov ds, ax

    mov si, msg
    call print

hang:
    hlt
    jmp hang

print:
    lodsb
    test al, al
    je .done
    mov ah, 0x0E
    mov bh, 0
    int 0x10
    jmp print
.done:
    ret

msg db "test!", 0
