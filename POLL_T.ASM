; POLL_T.ASM — Polling con timeout para el puerto de teclado
; Compila: nasm -f bin POLL_T.ASM -o POLL_T.COM

[BITS 16]
[ORG 0x100]

MAX_RETRY EQU 0005h

start:
    MOV CX, MAX_RETRY
.poll:
    ; Verificar con BIOS si hay tecla disponible (no bloquea)
    MOV AH, 01h
    INT 16h             ; ZF=1 si NO hay tecla, ZF=0 si hay tecla
    JNZ .dato_listo     ; si hay tecla, ir a leerla
    LOOP .poll          ; decrementa CX; salta si CX≠0

    ; Timeout: CX llegó a 0 sin dato
    MOV AH, 09h
    MOV DX, msg_timeout
    INT 21h
    JMP .fin

.dato_listo:
    MOV AH, 00h
    INT 16h             ; leer la tecla: AH=scancode, AL=ASCII
    MOV BL, AH          ; guardar scancode

    ; Nibble alto
    MOV AH, 02h
    MOV DL, BL
    SHR DL, 4
    ADD DL, 30h
    CMP DL, 3Ah
    JL  .printH
    ADD DL, 07h
.printH:
    INT 21h

    ; Nibble bajo
    MOV AH, 02h
    MOV DL, BL
    AND DL, 0Fh
    ADD DL, 30h
    CMP DL, 3Ah
    JL  .printL
    ADD DL, 07h
.printL:
    INT 21h

    MOV AH, 02h
    MOV DL, 0Dh
    INT 21h
    MOV AH, 02h
    MOV DL, 0Ah
    INT 21h

.fin:
    MOV AH, 4Ch
    INT 21h

msg_timeout DB 'Timeout: sin respuesta del dispositivo$'