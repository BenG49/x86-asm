; https://github.com/luckytoilet/projecteuler-solutions/blob/master/Solutions.md
section .text
    global main
    
    extern print_digits
    extern exit

main:

    jmp exit

; def largest_prime_factor(n: int):
;     max = int(n/2)
;     largest = 0
;     for i in range(2, max):
;         if n%i == 0:
;             largest = i
;             n /= i
;     return largest

g_prime_fac:    ; rax is number to factorize (later rcx)
    push rax
    xor rdx, rdx    ; clear high word
    mov rbx, 2      ; set max try to (int)rax/2
    div rbx
    pop rcx         ; number to factorize = rcx
p_loop:
    push rax        ; move rax to temp location

    pop rax

    cmp rbx, rax
    jle p_loop
    ret

fib_even:   ; call with 4000000
    xor rbx, rbx    ; sum register = 0
    xor rcx, rcx    ; prev = 0
    mov rdx, 1      ; current = 1
e2_loop:
    push rax
    mov rax, rdx    ; set rax to current
    and rax, 1      ; check low bit

    jnz e2_cont     ; if odd, cont
    add rbx, rdx    ; accumulate
e2_cont:
    pop rax
    push rdx        ; temp = current
    add rdx, rcx    ; current += prev
    pop rcx         ; prev = temp

    cmp rdx, rax    ; continue if less than rax
    jl e2_loop

    mov rax, rbx
    ret

sum_3_5: ; call with 1000
    xor rbx, rbx    ; sum register
    xor rcx, rcx    ; counter
_3loop:
    add rbx, rcx    ; accumulate
    add rcx, 3
    cmp rcx, rax
    jl _3loop       ; if greater than or equal to n move to fives
        ; init 5
    xor rcx, rcx    ; 5 counter
_5loop:
    add rbx, rcx    ; accumulate
    add rcx, 5
    cmp rcx, rax
    jl _5loop       ; if greater than or equal to n move to 15
        ; init 15
    xor rcx, rcx    ; 15 counter
_15loop:
    sub rbx, rcx    ; sub
    add rcx, 15
    cmp rcx, rax
    jl _15loop

    mov rax, rbx
    ret