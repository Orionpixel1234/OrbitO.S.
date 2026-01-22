[BITS 16] ;; SET BY BIOS REALMODE
[ORG 0x7C00] ;; ORIGIN FOR BOOTLOADER

main:
    CLI ;; NO INTERUPTS
    XOR AX, AX ;; SET
    MOV DS, AX ;; UP
    MOV ES, AX ;; THE
    MOV DS, AX ;; STACK
    MOV SP, 0x7A00 ;; STACK POINTER
    STI ;; MORE INTERUPTS
    
    MOV [boot_drive], DL ;; SAVE BOOT DRIVE

read_drive:
    ;; READ SECTORS FROM DRIVE
    ;; INT 0x13
    ;; AH = 0x42
    ;; DL = [boot_drive]
    ;; DS:SI = DAP
    ;; SEE MORE @ https://en.wikipedia.org/wiki/INT_13H#INT_13h_AH=42h:_Extended_Read_Sectors_From_Drive
    MOV AH, 0x42
    MOV DL, [boot_drive]
    MOV SI, dap
    INT 0x13
    JC .error

    JMP .read_ok

.error:
    ;; RESET DISK
    ;; INT 0x13
    ;; AH = 0x00
    ;; DL = [boot_drive]
    ;; SEE MORE @ https://en.wikipedia.org/wiki/INT_13H#INT_13h_AH=00h:_Reset_Disk_System
    XOR AH, AH
    MOV DL, [boot_drive]
    INT 0x13
    JC halt
    
    ;; RETRY 5 TIMES
    DEC BYTE [retries]
    JNZ read_drive

.read_ok:
    ;; JUMP TO BOOT NUM 2 (ASM ADAPTER)
    JMP 0x0000:0x7E00

halt:
    HLT ;; HALT
    JMP halt ;; YOU SHALL NOT PASS

;; SEE DEFINITION @ https://en.wikipedia.org/wiki/INT_13H#INT_13h_AH=42h:_Extended_Read_Sectors_From_Drive
dap:
    DB 0x10 ;; SIZE
    DB 0 ;; RESERVED FOR RESERVATION (ON THE DISNEY MOBILE APP)
    DW 4 ;; NUMBER OF SECTORS TO READ (4 SECTORS THATS ALOT TO READ!)
    DW 0x7E00 ;; OFFSET!!
    DW 0x0000 ;; SEGMENT!
    DQ 1 ;; (0 DOES NOT WORK)

boot_drive DW 0 ;; BOOT DRIVE
retries DB 5 ;; 5 RETRIES OF THE DISK READING

TIMES 510-($-$$) DB 0 ;; PADDING FOR WHEN YOU FALL
DW 0xAA55 ;; BOOT SIGNATURE (WEIRD NAME HUH)