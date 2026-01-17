[BITS 16] ;; REAL MODE!!!
[ORG 0x7E00] ;; ROOMMATES WITH BOOT.ASM (0x7C00)

main:
    XOR AX, AX ;; AX = 0
    MOV DS, AX ;; DS = 0 0x0000:
    MOV ES, AX ;; ES = 0 0x0000

    MOV SI, msg ;; MSG FOR YOU
    CALL print ;; PRINT IT

hang:
    HLT ;; HALT
    JMP hang ;; YOU SHALL NOT PASS

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

msg DB "test!", 0 ;; MSG
