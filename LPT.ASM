; LPT1.ASM — Envío de un carácter al puerto paralelo LPT1 (Centronics)
; Compila: nasm -f bin LPT1.ASM -o PARPORT.COM

[BITS 16]
[ORG 0x100]

DATA_PORT   EQU 0378h
STATUS_PORT EQU 0379h
CTRL_PORT   EQU 037Ah

start:
    ; (0) Esperar BUSY# = 1 con timeout
    MOV CX, 0FFFFh
.wait_ready:
    MOV DX, STATUS_PORT
    IN  AL, DX
    TEST AL, 80h
    JNZ .send
    LOOP .wait_ready
    JMP .fin

.send:
    ; (1) Colocar dato en Data Register
    MOV DX, DATA_PORT
    MOV AL, 41h         ; 'A'
    OUT DX, AL

    ; (2) STROBE = 1 (activo)
    MOV DX, CTRL_PORT
    IN  AL, DX
    OR  AL, 01h
    OUT DX, AL

    ; Retardo ~1µs
    MOV CX, 0Fh
.delay_strobe:
    LOOP .delay_strobe

    ; (3) STROBE = 0 (inactivo)
    MOV DX, CTRL_PORT
    IN  AL, DX
    AND AL, 0FEh
    OUT DX, AL

    ; (4) Esperar ACK con timeout
    MOV CX, 0FFFFh
.wait_ack:
    MOV DX, STATUS_PORT
    IN  AL, DX
    TEST AL, 40h
    JZ  .fin
    LOOP .wait_ack

.fin:
    MOV AH, 4Ch
    INT 21h