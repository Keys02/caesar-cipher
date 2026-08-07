;   Executable name : caesarcipher
;   Version         : 1.0
;   Created date    : Mon, 07/08/2026
;   Last Update     : Mon, 07/08/2026
;   Author          : Opoku N. Chris
;   Description     : An assembly language program that encypts 
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

section .data                   ; Section for initialized data       


section .bss                    ; Section for uninitialized data


section .text                   ; Section for the code

global main                     ; Define the entry point of the program for the linker

main:
    mov rbp,rsp                 ; Put the stack pointer in the extension base pointer, Debugger --> :)
        