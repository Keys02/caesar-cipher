section .data                       ; Section for initialized data 
    StatMsg: db "Encrypting...",0Ah
    StatLen: equ $-StatMsg
    DoneMsg: db "..done!",0Ah
    DoneLen: equ $-DoneMsg

; The translation table shifts all alphabets by 3 mimicking the Caesar Cipher algorithm
    CaesarCipher:
    db 00h, 01h, 02h, 03h, 04h, 05h, 06h, 07h, 08h, 09h, 0Ah, 0Bh, 0Ch, 0Dh, 0Eh, 0Fh
    db 10h, 11h, 12h, 13h, 14h, 15h, 16h, 17h, 18h, 19h, 1Ah, 1Bh, 1Ch, 1Dh, 1Eh, 1Fh
    db 20h, 21h, 22h, 23h, 24h, 25h, 26h, 27h, 28h, 29h, 2Ah, 2Bh, 2Ch, 2Dh, 2Eh, 2Fh
    db 30h, 31h, 32h, 33h, 34h, 35h, 36h, 37h, 38h, 39h, 3Ah, 3Bh, 3Ch, 3Dh, 3Eh, 3Fh
    db 40h, 44h, 45h, 46h, 47h, 48h, 49h, 4Ah, 4Bh, 4Ch, 4Dh, 4Eh, 4Fh, 50h, 51h, 52h
    db 53h, 54h, 55h, 56h, 57h, 58h, 59h, 5Ah, 41h, 42h, 43h, 5Bh, 5Ch, 5Dh, 5Eh, 5Fh
    db 60h, 64h, 65h, 66h, 67h, 68h, 69h, 6Ah, 6Bh, 6Ch, 6Dh, 6Eh, 6Fh, 70h, 71h, 72h
    db 73h, 74h, 75h, 76h, 77h, 78h, 79h, 7Ah, 61h, 62h, 63h, 7Bh, 7Ch, 7Dh, 7Eh, 7Fh
    db 080h,081h,082h,083h,084h,085h,086h,087h,088h,089h,08Ah,08Bh,08Ch,08Dh,08Eh,08Fh
    db 090h,091h,092h,093h,094h,095h,096h,097h,098h,099h,09Ah,09Bh,09Ch,09Dh,09Eh,09Fh
    db 0A0h,0A1h,0A2h,0A3h,0A4h,0A5h,0A6h,0A7h,0A8h,0A9h,0AAh,0ABh,0ACh,0ADh,0AEh,0AFh
    db 0B0h,0B1h,0B2h,0B3h,0B4h,0B5h,0B6h,0B7h,0B8h,0B9h,0BAh,0BBh,0BCh,0BDh,0BEh,0BFh
    db 0C0h,0C1h,0C2h,0C3h,0C4h,0C5h,0C6h,0C7h,0C8h,0C9h,0CAh,0CBh,0CCh,0CDh,0CEh,0CFh
    db 0D0h,0D1h,0D2h,0D3h,0D4h,0D5h,0D6h,0D7h,0D8h,0D9h,0DAh,0DBh,0DCh,0DDh,0DEh,0DFh
    db 0E0h,0E1h,0E2h,0E3h,0E4h,0E5h,0E6h,0E7h,0E8h,0E9h,0EAh,0EBh,0ECh,0EDh,0EEh,0EFh
    db 0F0h,0F1h,0F2h,0F3h,0F4h,0F5h,0F6h,0F7h,0F8h,0F9h,0FAh,0FBh,0FCh,0FDh,0FEh,0FFh
    
section .bss                        ; Section for uninitialized data
    READLEN equ 1024                ; Length of buffer
    ReadBuffer: resb READLEN        ; Define a buffer with length 1024 bytes

section .text                       ; Section for the code

global main                         ; Define the entry point of the program for the linker

main:
    mov rbp, rsp                    ; Put the stack pointer into the extension base pointer, debuggers --> :)
    
; Display the "I'm working..." message via stderr:
    mov rax,1                       ; Declare a sys_write operation
    mov rdi,2                       ; Use File Descriptor 2 ie stderr
    mov rsi,StatMsg                 ; Pass the address of the message
    mov rdx,StatLen                 ; Pass the length of the message
    syscall                         ; Make the kernel call

; Read text from stdin into a buffer
read:
    mov rax,0                       ; Declare a sys_read operation
    mov rdi,0                       ; Use File Descriptor 0 ie stdin
    mov rsi,ReadBuffer              ; Pass the address of the buffer to read to
    mov rdx,READLEN                 ; Pass the number of bytes to read at one pass
    syscall                         ; Make kernel call
    mov rbp,rax                     ; Copy sys_read return value for use later
    cmp rax,0                       ; If rax=0, sys_read reached EOF
    je Done                         ; Jump if the read operation returned zero(0)
    
; Set up the registers for the translate step:
    mov rbx,CaesarCipher            ; Put the address of the table into rbx
    mov rdx,ReadBuffer              ; Put the address of the buffer into rdx
    mov rcx,rbp                     ; Put the number of bytes into rcx
    
; Use the xlat instruction to translate the data in the buffer:
translate:
    xor rax,rax                     ; Clear out RAX register
    mov al,byte [rdx-1+rcx]         ; Load character from the buffer into AL register for translation
    mov al,[rbx+rax]                ; Translate chracter in AL via translation table
;   xlat                            ; This does the same thing as the the line above
    mov byte [rdx-1+rcx],al         ; Put the xlated character back in the buffer
    dec rcx                         ; Decrement the number of characters translated in the buffer
    jnz translate                   ; If there are more characters to be translated, repeat
    
; Write the buffer full of translated text to stdout:
write:
    mov rax,1                       ; Declare a sys_write operation
    mov rdi,1                       ; Use File Descriptor 1 ie stdout
    mov rsi,ReadBuffer              ; Pass the address of the buffer to print
    mov rdx,rbp                     ; Pass the # of bytes of data in the buffer
    syscall                         ; Make kernel call
    jmp read
    
Done:
    mov rax,1                       ; Declare a sys_write call operation
    mov rdi,2                       ; Specify File Descriptor 2 ie stderr
    mov rsi,DoneMsg                 ; Pass address of the message
    mov rdx,DoneLen                 ; Pass the length of the message
    syscall
    
; All done! 
    ret                             ; Return to the glibc shutdown code