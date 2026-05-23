; TECL.ASM — Lectura de scancode con INT 16h
; Compila: nasm -f bin TECL.ASM -o TECL.COM

[BITS 16]
[ORG 0x100]

start:
    ; Leer tecla con BIOS — AH=00h espera y devuelve:
    ;   AH = scancode, AL = código ASCII
    MOV AH, 00h
    INT 16h         ; BIOS keyboard: AH = scancode

    MOV BL, AH      ; guardar scancode en BL

    ; --- Nibble alto ---
    MOV AH, 02h
    MOV DL, BL
    SHR DL, 4
    ADD DL, 30h
    CMP DL, 3Ah
    JL  .printH
    ADD DL, 07h
.printH:
    INT 21h

    ; --- Nibble bajo ---
    MOV AH, 02h
    MOV DL, BL
    AND DL, 0Fh
    ADD DL, 30h
    CMP DL, 3Ah
    JL  .printL
    ADD DL, 07h
.printL:
    INT 21h

    ; --- CR + LF ---
    MOV AH, 02h
    MOV DL, 0Dh
    INT 21h
    MOV AH, 02h
    MOV DL, 0Ah
    INT 21h

    JMP start       ; siguiente tecla

.fin:
    MOV AH, 4Ch
    INT 21h