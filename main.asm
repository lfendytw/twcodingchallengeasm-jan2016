global start                             ; make 'start' function externally visible

section .bss
mid_letter   resb   1          ; resb 1 (Reserve 1 byte) for a variable 'mid_letter'
var_a        resb   1          ; resb 1 (Reserve 1 byte) for a variable 'mid_letter'

section .text

%define SYS_write 4
%define SYS_exit  1

myprint:
    mov     eax, SYS_write   ; put the system call number (write=4) to register 'a'
    int     0x80             ; CPU interrupt actually makes the system call
    ret

myexit:
    mov     eax, SYS_exit    ; put the system call number (exit=1) to register 'a'
    int     0x80             ; CPU interrupt to actually make the system call
    ; no need ret

start:
; get commandline argument
    add     esp, byte 8      ; discard argc (4 bytes) and argv[0] (another 4 bytes)
    pop     ecx              ; next in stack is argv[1], pop and put into register 'c'
    mov     [mid_letter], ecx ; mid_letter = ecx
    pop     ecx              ; next in stack is argv[1], pop and put into register 'c'
    mov     [var_a], ecx ; mid_letter = ecx

l1:
    push    dword 1          ; number of bytes to write (1)
    push    dword [mid_letter]; mid_letter shd contain commandline argument
    push    dword 1          ; file descriptor
    call    myprint
    ; clean up
    ;loop l1

    push    dword 1          ; number of bytes to write (1)
    push    dword [var_a]; mid_letter shd contain commandline argument
    push    dword 1          ; file descriptor
    call    myprint
    ; clean up
    add     esp, 12          ; 3 args * 4 bytes + 4 bytes extra space = 16
    ; jecxz   next
    ;loop l1


    ; ; debugging commandline argument
    ; push    dword 1          ; number of bytes to write (1)
    ; push    dword ecx        ; mid_letter shd contain commandline argument
    ; push    dword 1          ; file descriptor
    ; call    myprint
    ; ; clean up
    ; add     esp, 12          ; 3 args * 4 bytes + 4 bytes extra space = 16



next:
; 1 print
    ; 1a prepare arguments for system call to write
    push    dword char_a.len ; message length               is first
    push    dword char_a     ; the (pointer) to the message is second
    push    dword 1          ; file descriptor (1 = STDOUT) is last

    ; 1b actually make system call to write
    call    myprint

    ; 1c clean up stack
    add     esp, 12          ; 3 args * 4 bytes + 4 bytes extra space = 16

; 2 exit program
    ; 2a prepare argument for system call to exit
    push    dword 0          ; 0 is the exit status  = the first and only argument
    ; 2b make call
    call    myexit
    ; no need to clean up because no code is executed here

section .data

char_space: db  " "            ; the 'space' character
.len:       equ $ - char_space ; string length in bytes
char_a:     db  "A"            ; the letter A
.len:       equ $ - char_a     ; string length in bytes
