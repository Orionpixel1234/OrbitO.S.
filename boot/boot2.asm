[BITS 16] ;; REAL MODE!!!
[ORG 0x7E00] ;; ROOMMATES WITH BOOT.ASM (0x7C00)

CODE_SEG equ 0x08
DATA_SEG equ 0x10

main:
    XOR AX, AX ;; AX = 0
    MOV DS, AX ;; DS = 0 0x0000:
    MOV ES, AX ;; ES = 0 0x0000

    MOV SI, msg ;; MSG FOR YOU
    CALL print ;; PRINT IT

    CLI ;; NO MORE INTERUPS CPU!!
    LGDT [gdt_descriptor] ;; LOAD THIS GDT

    MOV EAX, CR0 ;; EAX GETS CR0 CR0
    OR EAX, 1 ;; SET PE BIT TO CR0
    MOV CR0, EAX ;; SAVE TO CR0
    JMP CODE_SEG:pm_entry ;; JUMP TO FUNC

hang_rm:
    HLT ;; HALT
    JMP hang_rm ;; YOU SHALL NOT PASS

print:
    LODSB ;; LOAD FROM SI
    TEST AL, AL ;; IF AL = 0 CONT BELOW
    JE .done ;; JUMP TO .DONE CONT ABOVE
    MOV AH, 0x0E ;; PRINT
    MOV BH, 0 ;; THE
    INT 0x10 ;; LINE
    JMP print ;; LOOP
.done:
    RET ;; RETURN TO FUNC THAT CALLED IT

gdt_start:
    DQ 0 ;; NULL DESCRIPTOR
    ;; CODE SEGMENT
    DW 0xFFFF ;; SEG LIMIT
    DW 0x0000 ;; LOW 16 BITS
    DB 0x00 ;; NEXT 8 BITS (IM MISSING MY OTHER 8 BITS!!)
    DB 10011010b ;; ACCESS BYTE: PRESENT, RING 0, CODE SEGMENT
    DB 11001111b ;; FLAGS: 4K GRANULARITY, 32 BITS
    DB 0x00 ;; OTHER 8 BITS (OOOP FOUND IT :P)
    ;; DATA SEGMENT (I THINK)
    DW 0xFFFF ;; SEG LIMIT
    DW 0x0000 ;; LOW 16 BITS
    DB 0x00 ;; NEXT 8 BITS (I LOST THE 8 BITS SRY)
    DB 10010010b ;; ACCESS: PRESENT, RING 0, DATA SEGMENT
    DB 11001111b ;; FLAGS: 4K GRANULARITY, 32 BITS
    DB 0x00 ;; OTHER 8 BITS (YO I FOUND THE OTHER 8 BITS)

gdt_end:

gdt_descriptor:
    DW gdt_end - gdt_start - 1 ;; DESCRIPTOR
    DD gdt_start ;; OTHER DESCRIPTOR

[BITS 32] ;; YESS PROTECTED MODE!!
pm_entry:
    MOV AX, DATA_SEG ;; AX = DATA_SEG FOR SETTING SEGMENTS
    MOV DS, AX ;; DS = DATA_SEG
    MOV ES, AX ;; ES = DATA_SEG
    MOV SS, AX ;; SS = DATA_SEG
    MOV ESP, 0x90000 ;; STACK POINTER TO 0x90000

    EXTERN kmain ;; EXTERNAL KMAIN FUNC
    CALL kmain ;; CALL KMAIN FUNC (IN BOOT.C)
    
hang_pm:
    CLI ;; NO INTERUPTS
    HLT ;; HALT
    JMP hang_pm ;; STOP


msg DB "test!", 0 ;; MSG
