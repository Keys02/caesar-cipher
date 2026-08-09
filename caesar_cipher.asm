;   Executable name : caesarcipher
;   Version         : 1.0
;   Created date    : Mon, 07/08/2026
;   Last Update     : Mon, 07/08/2026
;   Author          : Opoku N. Chris
;   Description     : A utility program that encrypts 
;                     and decrypts text using Caesar Cipher algorithm
;
; Build using these commands:
;   nasm -­f elf64 -­g -­ F stabs caesarcipher.asm
;   ld -­ o caesarcipher caesarcipher.o
;               or
;   Using SASM editor build and save the the program as an exe file
;
; Running the program
;   exefilename < input file > output file
;               or
;   echo "[Message]" | exefilename
;   to run the program
;
;   If an output file is not specified, output goes to stdout

default rel                     ; Use Register Instruction Pointer(RIP)-relative addressing (REL)
                                ; Compute the address relative to the current instruction pointer (RIP)
                                ; Supress warning: implicit DEFAULT ABS is deprecated [-w+implicit-abs-deprecated]

section .data                       ; Section for initialized data
    StatEncMsg: db "Encrypting...",0Ah
    StatEncMsgLen: equ $-StatEncMsg
    StatDecMsg: db "Decrypting...",0Ah
    StatDecMsgLen: equ $-StatDecMsg     
    DoneMsg: db "..done!",0Ah
    DoneLen: equ $-DoneMsg
    Quest: db "Do you want to perform an Encryption/Decryption",0Ah
           db "1: Encryption",0Ah
           db "2: Decryption",0Ah
    QuestLen: equ $-Quest
    EncResultPreMsg: db "The encrypted message is "
    EncResultPreMsgLen: equ $-EncResultPreMsg
    DecResultPreMsg: db "The decrypted message is "
    DecResultPreMsgLen: equ $-DecResultPreMsg
    EntryMsg: db "Enter message: "
    EntryMsgLen: equ $-EntryMsg
    newline: db 0Ah
    

; The translation table shifts all alphabets forward by 3 mimicking the Caesar Cipher
; encryption algorithm
    CaesarCipherEncrypt:
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
    
; The translation table shifts all alphabets back by 3 mimicking the Caesar Cipher
; decryption algorithm
    CaesarCipherDecrypt:
    db 00h, 01h, 02h, 03h, 04h, 05h, 06h, 07h, 08h, 09h, 0Ah, 0Bh, 0Ch, 0Dh, 0Eh, 0Fh
    db 10h, 11h, 12h, 13h, 14h, 15h, 16h, 17h, 18h, 19h, 1Ah, 1Bh, 1Ch, 1Dh, 1Eh, 1Fh
    db 20h, 21h, 22h, 23h, 24h, 25h, 26h, 27h, 28h, 29h, 2Ah, 2Bh, 2Ch, 2Dh, 2Eh, 2Fh
    db 30h, 31h, 32h, 33h, 34h, 35h, 36h, 37h, 38h, 39h, 3Ah, 3Bh, 3Ch, 3Dh, 3Eh, 3Fh
    db 40h, 58h, 59h, 5Ah, 41h, 42h, 43h, 44h, 45h, 46h, 47h, 48h, 49h, 4Ah, 4Bh, 4Ch
    db 4Dh, 4Eh, 4Fh, 50h, 51h, 52h, 53h, 54h, 55h, 56h, 57h, 5Bh, 5Ch, 5Dh, 5Eh, 5Fh
    db 60h, 78h, 79h, 7Ah, 61h, 62h, 63h, 64h, 65h, 66h, 67h, 68h, 69h, 6Ah, 6Bh, 6Ch
    db 6Dh, 6Eh, 6Fh, 70h, 71h, 72h, 73h, 74h, 75h, 76h, 77h, 7Bh, 7Ch, 7Dh, 7Eh, 7Fh
    db 080h,081h,082h,083h,084h,085h,086h,087h,088h,089h,08Ah,08Bh,08Ch,08Dh,08Eh,08Fh
    db 090h,091h,092h,093h,094h,095h,096h,097h,098h,099h,09Ah,09Bh,09Ch,09Dh,09Eh,09Fh
    db 0A0h,0A1h,0A2h,0A3h,0A4h,0A5h,0A6h,0A7h,0A8h,0A9h,0AAh,0ABh,0ACh,0ADh,0AEh,0AFh
    db 0B0h,0B1h,0B2h,0B3h,0B4h,0B5h,0B6h,0B7h,0B8h,0B9h,0BAh,0BBh,0BCh,0BDh,0BEh,0BFh
    db 0C0h,0C1h,0C2h,0C3h,0C4h,0C5h,0C6h,0C7h,0C8h,0C9h,0CAh,0CBh,0CCh,0CDh,0CEh,0CFh
    db 0D0h,0D1h,0D2h,0D3h,0D4h,0D5h,0D6h,0D7h,0D8h,0D9h,0DAh,0DBh,0DCh,0DDh,0DEh,0DFh
    db 0E0h,0E1h,0E2h,0E3h,0E4h,0E5h,0E6h,0E7h,0E8h,0E9h,0EAh,0EBh,0ECh,0EDh,0EEh,0EFh
    db 0F0h,0F1h,0F2h,0F3h,0F4h,0F5h,0F6h,0F7h,0F8h,0F9h,0FAh,0FBh,0FCh,0FDh,0FEh,0FFh
        
section .bss                        ; Section for uninitialized data
    OPTLEN equ 3                   ; Define the length of the encryption & decryption option buffer
    MSGLEN equ 1024                 ; Define the length of the message buffer
    OptBuff: resb OPTLEN            ; Define the buffer to take user's option    
    MsgBuff: resb MSGLEN            ; Define the buffer to take user's message to be encrypted or decrypted


section .text                       ; Section for the code

global main                         ; Define the entry point of the program for the linker

main:
    mov rbp,rsp                     ; Put the stack pointer in the extension base pointer, Debugger --> :)
    
; Write the Question:
    mov rax,1                       ; Declare a sys_write operation
    mov rdi,1                       ; Use file descriptor 1 ie stdout
    mov rsi,Quest                   ; Pass the address of the question message
    mov rdx,QuestLen                ; Pass the # of bytes of the question message
    syscall                         ; Make kernel call


; Prepare registers for processing the uesr's option whether to perform an encryption or decryption operation:
    lea rbx,[OptBuff]               ; Put the address of the option buffer in rbx    
    
; Read the user's option:
ReadOpt:
    mov rax,0                       ; Declare a sys_read operation
    mov rdi,0                       ; Use File Descriptor 0 ie stdin
    mov rsi,rbx                     ; Pass the address ofAdd variabloe... the buffer to read the user option to
    mov rdx,1                       ; Pass the # of bytes to read at one pass
    syscall                         ; Make kernel call
    
; Null terminate the buffer if the there is no character left:
    cmp rax,0                       ; Check if there is no character to be read from stdin
    jle NullTerminateOptBuff         ; Null terminate the buffer if there exist no character to be read
    
; Null terminate the buffer if the character read is a newline:
    mov al,byte [rbx]                    ; Put the character read in 8-bit al register
    cmp al,0Ah                      ; Check if the character read is a newline
    je NullTerminateOptBuff         ; Null terminate the buffer if there exist no character to be read
    
; Read the next buffer:
    inc rbx                         ; Increase the option buffer address pointer
    jmp ReadOpt                     ; Read the next character
    
NullTerminateOptBuff:
    mov byte [rbx],0                ; Null terminate the buffer

; Write the Entry Message:
    mov rax,1                       ; Declare a sys_write operation
    mov rdi,1                       ; Use file descriptor 1 ie stdout
    mov rsi,EntryMsg                ; Pass the address of the question message
    mov rdx,EntryMsgLen             ; Pass the # of bytes of the question message
    syscall                         ; Make kernel call
    
; Prepare registers for processing the user's message to be encrypted or decrypted:
    lea rbx,[MsgBuff]               ; Put the start of the message buffer in register rdx

ReadMsg:
; Read the message to be encrypted into a buffer
    mov rax,0                       ; Declare a sys_read operation
    mov rdi,0                       ; Use File Descriptor 0 ie stdin
    mov rsi,rbx                     ; Pass the address of the buffer to read the message to
    mov rdx,1                       ; Pass the # of bytes to read
    syscall                         ; Make kernel call

; Null terminate the buffer if the there is no character left:
    cmp rax,0                       ; Check if there is no character to be read from stdin
    jle NullTerminateMsgBuff         ; Null terminate the buffer if there exist no character to be read from stdin
    
; Null terminate the buffer if the character read is a newline:    
    mov al,byte [rbx]               ; Put the character read in AL 8-bit register
    cmp al,0Ah                      ; Check if the character is a newline character
    je NullTerminateMsgBuff         ; Null terminate the buffer if the character read is a newline

; Read the next buffer:
    inc rbx                         ; Increase the message buffer address pointer
    jmp ReadMsg                     ; Read the next byte in the message

NullTerminateMsgBuff:
    mov byte [rbx],0                ; Null terminate the buffer
    
; Get the number of bytes in the message buffer:
    lea r12,[MsgBuff]               ; Put the start of the message buffer in register r12
    sub rbx,r12                     ; Subtract the offset of the start of the message buffer from the end to get the # of 
                                    ; bytes in the message buffer
    mov r12,rbx                     ; Store the # of bytes in the message buffer in register r12

    call Newline                    ; Print a newline
    
; Decide the operation to be performed according to the user's option
    cmp byte [OptBuff],'1'          ; Start an encryption operation if the user choses option 1
    je Encrypt                      ; Jump to encryption procedure if option 1 is chosen
    cmp byte [OptBuff],'2'          ; Start a decryption operation if the user choses option 2
    je Decrypt                      ; Jump to decryption procedure if option 2 is chosen
    jmp Done
    
Encrypt:
; Display the encryption status message via stderr:
    mov rax,1                       ; Declare a sys_write operation
    mov rdi,2                       ; Use File Descriptor 2 ie stderr
    mov rsi,StatEncMsg              ; Pass the address of the message
    mov rdx,StatEncMsgLen           ; Pass the length of the message
    syscall                         ; Make the kernel call
    
; Prepare registers for the encryption operation
    mov rbx,CaesarCipherEncrypt     ; Put the address of encryption translation table in rbx register
    lea rcx,[MsgBuff]               ; Put the address of the message buffer in rcx register
    mov rsi,r12                     ; Put the # of bytes in the message buffer in rsi
    jmp translate                   ; Translate the chrarcters using the translation table
   
Decrypt:    
; Display the decryption status message via stderr:
    mov rax,1                       ; Declare a sys_write operation
    mov rdi,2                       ; Use File Descriptor 2 ie stderr
    mov rsi,StatDecMsg              ; Pass the address of the message
    mov rdx,StatDecMsgLen           ; Pass the length of the message
    syscall                         ; Make the kernel call
    
; Prepare registers for the decryption operation:
    mov rbx,CaesarCipherDecrypt     ; Put the address of decryption translation table in rbx register
    lea rcx,[MsgBuff]               ; Put the address of the message buffer in rcx register
    mov rsi,r12                     ; Put the # of bytes in the message buffer in rsi
    jmp translate                   ; Translate the characters using the translation table
    
translate:
    xor rax,rax                     ; Clear out the RAX register to be used for character translation
    mov al, byte [rcx-1+rsi]        ; Fetch a character from the message buffer ; Segmentation Fault Occurs here because of usage of register r12
    mov al, byte [rbx+rax]          ; Translate the fetched character using encryption or decryption translation table
    mov byte [rcx-1+rsi],al         ; Put the translation result back into the message buffer
    dec rsi                         ; Decrement the number of characters in the buffer
    jnz translate                   ; Keep translating the characters if buffer is not empty
    jmp WriteResult                 ; Jump to the operation if translation is complete

WriteResult:
    cmp byte [OptBuff],'1'
    je WriteEncResultPreMsg
    cmp byte [OptBuff],'2'
    je WriteDecResultPreMsg
    
WriteEncResultPreMsg:
    mov rax,1                       ; Declare sys_write operation
    mov rdi,1                       ; Use File Descriptor 1 ie stdout
    mov rsi,EncResultPreMsg         ; Pass the address of the message buffer
    mov rdx,EncResultPreMsgLen      ; Pass the # of bytes in the message buffer
    syscall                         ; Make kernel call
    jmp WriteOptResult              ; Jump to the procedure which outputs the content of the encrypted message
    
WriteDecResultPreMsg:
    mov rax,1                       ; Declare sys_write operation
    mov rdi,1                       ; Use File Descriptor 1 ie stdout
    mov rsi,DecResultPreMsg         ; Pass the address of the message buffer
    mov rdx,DecResultPreMsgLen      ; Pass the # of bytes in the message buffer
    syscall                         ; Make kernel call
    jmp WriteOptResult              ; Jump to the procedure which outputs the content of the decrypted message

WriteOptResult:
    mov rax,1                       ; Declare sys_write operation
    mov rdi,1                       ; Use File Descriptor 1 ie stdout
    mov rsi,MsgBuff                 ; Pass the address of the message buffer
    mov rdx,r12                     ; Pass the # of bytes in the message buffer
    syscall                         ; Make kernel call
    call Newline                    ; Print newline

Done:
    mov rax,1                       ; Declare a sys_write call operation
    mov rdi,2                       ; Specify File Descriptor 2 ie stderr
    mov rsi,DoneMsg                 ; Pass address of the message
    mov rdx,DoneLen                 ; Pass the length of the message
    syscall                         ; Make kernel call
    
; All done! 
    ret                             ; Return to the glibc shutdown code
    
; Newline Helper Routine:
Newline:
    mov rax,1                       ; Declare sys_write operation
    mov rdi,1                       ; Use file descriptior 1 ie stdout
    mov rsi,newline                 ; Pass the address of the newline character
    mov rdx,1                       ; Pass the length of the newline character
    syscall                         ; Make the sys_write system call
    ret