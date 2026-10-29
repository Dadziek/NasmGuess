section .data
        input_msg db 'Enter number = '
        len_msg equ $ - input_msg

        smaller_msg db 'Number is smaller than your guess', 0xA
        len_smaller equ $ - smaller_msg

        greater_msg db 'Number is greater than your guess', 0xA
        len_greater equ  $ - greater_msg

        win_msg db 'You won!', 0xA
        len_win equ $ - win_msg

section .bss
        bufor resb 20

section .text
global _start
_start:
        mov rcx, 100
.main:
        rdtsc
        xor rdx, rdx
        div rcx
        inc rcx
        mov r12, rdx
.game_loop:
        mov rax, 1
        mov rdi, 1
        mov rsi, input_msg
        mov rdx, len_msg
        syscall

        mov rax, 0
        mov rdi, 0
        mov rsi, bufor
        mov rdx, 20
        syscall
.convert:
        xor rax, rax
        xor rcx, rcx
.convert_loop:
        movzx rbx, byte [bufor + rcx]
        cmp bl, 0xA
        je .compare

        sub bl, '0'
        imul rax, rax, 10
        add rax, rbx
        inc rcx

        jmp .convert_loop
.compare:
        cmp rax, r12
        je .end
        jl .smaller
        jg .greater
.smaller:
        mov rax, 1
        mov rdi, 1
        mov rsi, greater_msg
        mov rdx, len_greater
        syscall

        jmp .game_loop
.greater:
        mov rax, 1
        mov rdi, 1
        mov rsi, smaller_msg
        mov rdx, len_smaller
        syscall

        jmp .game_loop
.end:
        mov rax, 1
        mov rdi, 1
        mov rsi, win_msg
        mov rdx, len_win
        syscall

        mov rdi, r12
        mov rax, 60
        syscall
