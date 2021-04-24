section .text
    global main
    global putstr
    global print_digits
    global exit
    global fib
    global strlen

fib:    ; max input of 46 before overflow stuff
    mov ecx, eax    ; move counter to ecx
    xor ebx, ebx    ; prev
    mov eax, 1      ; current
_fib_loop:
    ; print number
    push rax
    push rbx
    push rcx
    call print_digits
    pop rcx
    pop rbx
    pop rax

    mov edx, eax    ; temp = current
    add eax, ebx    ; current += prev
    mov ebx, edx    ; prev = temp
    sub ecx, 1      ; eax--
    jnz _fib_loop

    ret

print_digits:
    cmp eax, 10
    jl _single
    xor ecx, ecx    ; digit counter
    mov ebx, 10     ; divisor
_loop:
    xor edx, edx    ; clear high word of dividend
    div ebx         ; eax is output, edx is remainder

    push rdx        ; push onto stack
    inc ecx         ; inc digit count

    cmp eax, ebx
    jge _loop       ; if quotient is >= 10, continue

    push rax        ; push the last digit
    inc ecx
_endloop:
    dec ecx         ; dec digit count

    pop rax         ; take digit off stack

    push rcx        ; save the digit count on stack
    call print_num  ; print num
    pop rcx

    cmp ecx, 0
    jg _endloop
    mov rax, 10
    call print_reg
    ret
_single:
    call print_num
    mov rax, 10
    call print_reg
    ret

print_num:
    add rax, '0'
    call print_reg
    ret

print_reg:
    push rax

    mov rsi, rsp    ; pointer
    mov rax, 1      ; sys_write
    mov rdi, rax    ; file descriptor
    mov rdx, 1      ; byte count
    syscall

    add rsp, 8     ; reset stack ptr

    ret

putstr:
    push rax
    call strlen
    mov rdx, rax    ; byte count

    pop rax

    mov rsi, rax    ; pointer
    mov rax, 1      ; sys_write
    mov rdi, rax    ; file descriptor
    syscall

    ret

input:
    mov rsi, rax
    xor rax, rax
    xor rdi, rdi
    mov rdx, 16
    syscall

    ret

; http://www.int80h.org/strlen/
strlen:     ; takes in address of string in eax
    mov edi, eax    ; move addr into eax
    xor ecx, ecx
    not ecx         ; init ecx to -1
    xor al, al      ; byte to compare

    cld             ; clear flags
    repne scasb     ; while not equal flag
                    ; cmp memory byte addressed in edl relative to es to al

    not ecx         ; because ecx was being decremented every time
    dec ecx         ; just invert and add 1 to get len

    mov eax, ecx
    ret

exit:
    mov rax, 60     ; exit code
    xor rdi, rdi    ; error value
    syscall