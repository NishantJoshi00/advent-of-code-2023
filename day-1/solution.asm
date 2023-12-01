SYS_WRITE   equ 1 ; write text to stdout
SYS_READ    equ 0 ; read text from stdin
SYS_EXIT    equ 60 ; terminate the program
STDOUT      equ 1 ; stdout
STDIN       equ 0 ; stdin
LENGTH      equ 1 ; Length to read
NEWLINE     equ 10; ASCII newline

;--------------------------------------------------------------------------

section .bss
    current resb 1 ; To store the current 
    first   resb 1 ; To store the first digit
    second  resb 1 ; To store the second digit
    first_done  resb 1 ; To store the second digit
    total   resq 1 ; To store the total
    buffer  resb 22


;--------------------------------------------------------------------------

section .text
    global _start


input:
    mov     rax, SYS_READ
    mov     rdi, STDIN
    mov     rdx, LENGTH
    mov     rsi, current
    syscall


    cmp rax, 0
    je reset_exit

    ret

exit:
    xor     edi, edi  
    mov     rax, SYS_EXIT
    syscall

output:
    mov     rax, rdi           
    mov     rdi, buffer + 20   
    mov     rcx, 10            
    mov     rbx, 0             

.repeat:
    dec     rdi                
    xor     rdx, rdx          
    div     rcx              
    add     dl, '0'         
    mov     [rdi], dl      
    inc     rbx                

    test    rax, rax           
    jnz     .repeat            

    ; rbx now contains the number of digits in the string

    ; Move the string to the beginning of the buffer

    mov     rsi, rdi
    add     rsi, 20
    mov     byte [rsi], NEWLINE
    add     rsi, 1
    mov     byte [rsi], 0
    mov     rsi, rdi
    mov     rdi, STDOUT          ; Use STDOUT as file descriptor
    sub     rdx, rbx             ; Calculate string length
    mov     rax, SYS_WRITE       ; syscall number for sys_write
    syscall

    ret

main:
  call input

  movzx rax, byte [current]

  cmp rax, NEWLINE
  je reset


  cmp rax, '0'
  jl main
  cmp rax, '9'
  jg main

  sub byte [current], '0'
  
  cmp byte [first_done], 0
  je do_first

  jmp do_second


  call exit
  
do_first:
  mov al, byte [current]
  mov byte [first], al
  mov byte [second], al
  mov byte [first_done], 1
  jmp main

do_second:
  mov al, byte [current]
  mov byte [second], al
  jmp main

do_stuff:
  movzx rax, byte [first]
  imul rax, 10
  add qword [total], rax
  movzx rax, byte [second]
  add qword [total], rax
  ret

reset:
  call do_stuff

  mov     byte [first], 0
  mov     byte [second], 0
  mov     byte [first_done], 0

  mov     rdi, qword [total]
  call    output

  jmp main

reset_exit:
  call do_stuff

  mov     rdi, qword [total]
  call    output

  call exit

  

_start:
    mov     qword [total], 0
    mov     byte [first], 0
    mov     byte [second], 0
    mov     byte [first_done], 0

    call main



