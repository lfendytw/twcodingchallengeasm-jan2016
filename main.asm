global start                             ; make 'start' function externally visible

section .text
start:
; 1 print hello world
    ; 1a prepare arguments for system call to write
    push    dword msg.len    ; message length               is first
    push    dword msg        ; the (pointer) to the message is second
    push    dword 1          ; file descriptor (1 = STDOUT) is last

    ; 1b actually make system call to write
    mov     eax, 4           ; put the system call number (write=4) to register a
    sub     esp, 4           ; OSX system calls require extra space
    int     0x80             ; CPU interrupt actually makes the system call

    ; 1c clean up stack
    add     esp, 16          ; 3 args * 4 bytes + 4 bytes extra space = 16

; 2 exit program
    ; 2a prepare argument for system call to exit
    push    dword 0          ; 0 is the exit status  = the first and only argument
    mov     eax, 1           ; put the system call number (exit=1) to register a
    sub     esp, 12          ; clean up
    int     0x80             ; CPU interrupt to actually make the system call

section .data

msg:    db      "Hello, world!", 10  ; string with carriage return (ASCII byte 10)
.len:   equ     $ - msg              ; string length in bytes
