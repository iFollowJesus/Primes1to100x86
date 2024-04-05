section .text
global _start
_start:

out_loop_init:
  mov r8, 2       ;num
  xor r12, r12    ;primality boolean
  mov r9, r8      ;inner loop counter
  mov r10, 0      ;outer loop counter
  mov r11, 0      ;count by 2s offset

out_loop_head:
  mov rax, r8
  cmp rax, 100
  jge out_loop_foot
  
in_loop_init:
  mov r9, r8
  sub r9, 1
  
in_loop_head:
  cmp r9, 2
  jl in_loop_foot
  
  mov rax, r8
  mov rbx, r9 
  xor rdx, rdx
  div rbx
  sub r9, 1

  cmp rdx, 0
  je set_flag
  jmp in_loop_head
  
set_flag:
  mov r12, -1
  jmp in_loop_foot
  
in_loop_foot:
  ; if ecx == -1, jump to print_norm else jump to print_prime
  cmp r12, -1
  je print_norm
  jmp print_prime

print_prime:
; if rax >= 10, jump to print_prime_lg else jump to print_prime_sm
  mov rax, r8
  cmp rax, 10
  jge print_prime_lg
  jmp print_prime_sm

print_prime_sm:
  mov rax, r8
  mov edx, 1
  mov rcx, nums   ;set pointer
  add rcx, rax    ;advance pointer
  mov ebx, 1
  mov eax, 4
  int 0x80
  
  mov edx, prime_len
  mov ecx, prime_msg
  mov ebx, 1
  mov eax, 4
  int 0x80
  
  add r8, 1
  xor r12,r12
  jmp out_loop_head
  
print_prime_lg:
  mov rax, r8
  mov edx, 2
  mov rcx, nums   ;set pointer
  add rcx, rax    ;advance pointer
  add rcx, r11    ;add the offset
  mov ebx, 1
  mov eax, 4
  int 0x80
  
  mov edx, prime_len
  mov ecx, prime_msg
  mov ebx, 1
  mov eax, 4
  int 0x80
  
  add r8, 1
  add r11, 1
  xor r12, r12
  jmp out_loop_head

print_norm:
 mov rax, r8
 cmp rax, 10
 jge print_norm_lg
 jmp print_norm_sm
 
print_norm_sm:
  mov rax, r8
  mov edx, 1
  mov rcx, nums   ;set pointer
  add rcx, rax    ;advance pointer
  mov ebx, 1
  mov eax, 4
  int 0x80
  
  mov edx, norm_len
  mov ecx, norm_msg
  mov ebx, 1
  mov eax, 4
  int 0x80
  
  add r8, 1
  xor r12, r12
  jmp out_loop_head
 
print_norm_lg:
  mov rax, r8
  mov edx, 2
  mov rcx, nums   ;set pointer
  add rcx, rax    ;advance pointer
  add rcx, r11    ;add offset
  mov ebx, 1
  mov eax, 4
  int 0x80
  
  mov edx, norm_len
  mov ecx, norm_msg
  mov ebx, 1
  mov eax, 4
  int 0x80
  
  add r8, 1
  add r11, 1
  xor r12, r12
  jmp out_loop_head

out_loop_foot:
  mov eax, 1
  int 0x80

section .data
prime_msg   db  ' is prime.', 0x0a, 0x00
prime_len   equ $ - prime_msg
norm_msg    db  ' is not prime', 0x0a, 0x00
norm_len    equ $ - norm_msg
nums        db '0123456789101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899100'
