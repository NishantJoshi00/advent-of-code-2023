SYS_WRITE   equ 1 ; write text to stdout
SYS_READ    equ 0 ; read text from stdin
SYS_EXIT    equ 60 ; terminate the program
STDOUT      equ 1 ; stdout
STDIN       equ 0 ; stdin
LENGTH      equ 1 ; Length to read
NEWLINE     equ 10; ASCII newline

;--------------------------------------------------------------------------

section .data
  one   db "one",	  0
  two   db "two",	  0
  three db "three",	0
  four  db "four",	0
  five  db "five",	0
  six   db "six",	  0
  seven db "seven",	0
  eight db "eight",	0
  nine  db "nine",	0
  zero  db "zero",	0

;--------------------------------------------------------------------------

section .bss
  ibuffer resb 128
  total resq 1
  first resb 1
  second resb 1
  first_done resb 1
  current resb 1
  length resb 1
  buffer resb 22


;--------------------------------------------------------------------------

section .text
  global _start


input:
  mov rsi, ibuffer
.input_loop:
  mov rdi, STDIN
  mov rax, SYS_READ
  mov rdx, LENGTH
  syscall

  cmp rax, 0
  ; je reset_exit
  je exit

  cmp byte [rsi], NEWLINE
  je .end_input
  
  inc rsi
  jmp .input_loop

.end_input:
  mov rax, rsi
  sub rax, ibuffer
  mov [length], rax
  ret



do_first:
  mov al, byte [current]
  mov byte [first], al
  mov byte [second], al
  mov byte [first_done], 1
  jmp do_current.do_current_end

  ret

do_second:
  mov al, byte [current]
  mov byte [second], al
  jmp do_current.do_current_end

  ret


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

  ret



exit:
    xor     edi, edi  
    mov     rax, SYS_EXIT
    syscall

    ret

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


do_current:
  cmp byte [first_done], 0
  je do_first

  jmp do_second

.do_current_end:
  ret


check_digit:
  mov al, [rsi]

  cmp al, NEWLINE
  je main.main_end

  cmp al, '0'
  jl .continue

  cmp al, '9'
  jg .continue

  sub al, '0'
  mov byte [current], al
  
  call do_current

.continue:
  ret



strcmp:
  ; rsi ; points to buffer
  ; rdi ; points to sample string

  xor rcx, rcx
.cmp_loop:
  mov al, [rsi + rcx]
  cmp al, [rdi + rcx]
  je .continue_cmp

  xor rcx, rcx
  mov al, 1
  ret
.continue_cmp:
  inc rcx

  cmp byte [rsi + rcx], NEWLINE
  jne .not_zero

  cmp byte [rdi + rcx], 0
  je .EOB

  mov al, 1
  ret

.not_zero:
  cmp byte [rdi + rcx], 0
  je .EOB

  jmp .cmp_loop
.EOB:
  mov al, 0
  ret



check_1:
  mov rdi, one
  call strcmp
  cmp al, 0
  je .current_1
  ret
.current_1:
  mov byte [current], 1
  call do_current 
  ret


check_2:
  mov rdi, two
  call strcmp
  cmp al, 0
  je .current_2
  ret
.current_2:
  mov byte [current], 2
  call do_current
  ret


check_3:
  mov rdi, three
  call strcmp
  cmp al, 0
  je .current_3
  ret
.current_3:
  mov byte [current], 3
  call do_current
  ret


check_4:
  mov rdi, four
  call strcmp
  cmp al, 0
  je .current_4
  ret
.current_4:
  mov byte [current], 4
  call do_current
  ret

check_5:
  mov rdi, five
  call strcmp
  cmp al, 0
  je .current_5
  ret
.current_5:
  mov byte [current], 5
  call do_current
  ret


check_6:
  mov rdi, six
  call strcmp
  cmp al, 0
  je .current_6
  ret
.current_6:
  mov byte [current], 6
  call do_current
  ret


check_7:
  mov rdi, seven
  call strcmp
  cmp al, 0
  je .current_7
  ret
.current_7:
  mov byte [current], 7
  call do_current
  ret


check_8:
  mov rdi, eight
  call strcmp
  cmp al, 0
  je .current_8
  ret
.current_8:
  mov byte [current], 8
  call do_current
  ret


check_9:
  mov rdi, nine
  call strcmp
  cmp al, 0
  je .current_9
  ret
.current_9:
  mov byte [current], 9
  call do_current
  ret


check_0:
  mov rdi, zero
  call strcmp
  cmp al, 0
  je .current_0
  ret
.current_0:
  mov byte [current], 0
  call do_current
  ret

check_numbers:
  call check_0
  call check_1
  call check_2
  call check_3
  call check_4
  call check_5
  call check_6
  call check_7
  call check_8
  call check_9
  ret
  


main:
  call input

  mov rsi, ibuffer
.main_loop:
  call check_digit

  call check_numbers

  inc rsi
  jmp .main_loop

.main_end:
  jmp reset
  ret



output_input:
  mov rdi, STDOUT
  mov rax, SYS_WRITE
  mov rdx, 4
  mov rsi, ibuffer
  syscall

  ret


_start:
  mov qword [total], 0
  mov byte [first],0
  mov byte [second], 0
  mov byte [current], 0
  mov byte [first_done], 0


  ; mov rdi, [total]
  ; call output

  jmp main

  call exit


