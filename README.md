# Solano-Post1-U9

# Unidad 9: Entrada y Salida Avanzados

## Objetivo

Explorar el acceso directo a hardware mediante puertos de E/S en modo real x86, implementando tres programas en NASM que demuestran lectura de teclado con polling e interrupciones BIOS, polling con timeout, y escritura al puerto paralelo Centronics.

---

## Prerrequisitos

- DOSBox instalado y configurado
- NASM.EXE disponible en el directorio montado
- CWSDPMI.EXE en el mismo directorio

---

## Programas

### TECL.ASM — Lectura de scancode de teclado

**Objetivo:** leer el scancode de cada tecla presionada usando INT 16h del BIOS y mostrarlo en hexadecimal por pantalla.

**Compilación:**
```
nasm -f bin TECL.ASM -o TECL.COM
```

**Ejecución:**
```
TECL.COM
```

**Comportamiento esperado:** al presionar una tecla, muestra su scancode en hex seguido de CR+LF. Por ejemplo, al presionar A muestra `1E`.

<img width="630" height="364" alt="C1" src="https://github.com/user-attachments/assets/1e426597-f9c5-4cd8-bb20-ebd4087ef333" />

---

### POLL_T.ASM — Polling con timeout

**Objetivo:** demostrar un bucle de polling controlado con contador de reintentos para evitar bloqueos indefinidos cuando el dispositivo no responde.

**Compilación:**
```
nasm -f bin POLL_T.ASM -o POLL_T.COM
```

**Ejecución:**
```
POLL_T.COM
```

**Comportamiento esperado:** si se presiona una tecla antes de que CX llegue a 0, muestra el scancode en hex. Si no se presiona ninguna tecla, el contador expira y muestra `Timeout: sin respuesta del dispositivo`.

<img width="643" height="88" alt="C2" src="https://github.com/user-attachments/assets/a7fb20f0-7e7b-47db-86d9-32277e26ac2e" />

---

### LPT1.ASM — Escritura al puerto paralelo Centronics

**Objetivo:** implementar el protocolo Centronics completo sobre los puertos 0x378–0x37A: colocar dato, activar STROBE, desactivar STROBE y esperar ACK, todo con timeouts para evitar bloqueo.

**Compilación:**
```
nasm -f bin LPT.ASM -o LPT.COM
```

**Ejecución:**
```
LPT.COM
```

**Comportamiento esperado:** en DOSBox no hay impresora física, por lo que los timeouts de BUSY# y ACK expiran y el programa termina limpiamente devolviendo el prompt. Esto verifica que el protocolo se ejecuta sin bloqueo indefinido.

<img width="636" height="88" alt="C3" src="https://github.com/user-attachments/assets/6bf5f160-4d5c-47f3-b5b6-55f1481df9be" />

---

## Notas

- Los puertos 0x378–0x37A requieren usar DX como registro de puerto en las instrucciones IN/OUT, ya que superan el límite de 0FFh direccionable directamente.
- TECL.ASM usa INT 16h en lugar de polling directo al puerto 64h porque DOSBox no emula el bit OBF del 8042.
- Se cambio el nombre al programa LPT1.ASM que ahora se llama LPT.ASM y su archivo de salida LPT.COM porque LPT1 es un nombre reservado por DOS.
