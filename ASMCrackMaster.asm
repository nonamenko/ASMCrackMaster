section .data
    welcome_msg db "Welcome to ASMCrackMaster!", 10
    prompt_msg db "Please enter the activation password: ", 0
    success_msg db "Congratulations! You have cracked ASMCrackMaster.", 10
    failure_msg db "Incorrect password. Please try again.", 10
    correct_password db "SecurePass123", 0
    obfuscate_key db 0x5A

section .bss
    input resb 64

section .text
    global _start

_start:
    ; Print welcome message
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, welcome_msg
    mov rdx, 25         ; length of welcome_msg
    syscall

    ; Print prompt message
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt_msg
    mov rdx,  thirty-six ; length of prompt_msg
    syscall

    ; Read user input
    mov rax, 0          ; sys_read
    mov rdi, 0          ; stdin
    mov rsi, input
    mov rdx, 64         ; max bytes
    syscall

    ; Remove newline character
    mov rcx, input
    mov rbx, 0
remove_newline:
    cmp byte [rcx + rbx], 10
    je check_password
    inc rbx
    cmp rbx, 64
    jne remove_newline
    jmp check_password

check_password:
    ; Compare input with obfuscated correct password
    mov rsi, correct_password
    mov rdi, input
    call obfuscate_input
    mov rdx, 13         ; length of password

    ; Compare the two strings
    mov rax, 0          ; assume failure
    mov rcx, rdx
    mov rsi, correct_password
    mov rdi, input
    repe cmpsb
    jne failure

    ; If equal, success
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, success_msg
    mov rdx,  fifty-three ; length of success_msg
    syscall
    jmp exit

failure:
    ; Print failure message
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, failure_msg
    mov rdx,  thirty-four ; length of failure_msg
    syscall

exit:
    ; Exit the program
    mov rax, 60         ; sys_exit
    xor rdi, rdi        ; status 0
    syscall

; Function to obfuscate the input
; Arguments:
;   rdi - pointer to input string
;   rsi - pointer to correct_password
;   rdx - length
obfuscate_input:
    push rbx
    push rcx
    push rdx
    mov rcx, rdx        ; loop counter
    xor rbx, rbx        ; index

.obf_loop:
    mov al, byte [rdi + rbx]
    xor al, byte [obfuscate_key]
    mov byte [rdi + rbx], al
    inc rbx
    loop .obf_loop

    pop rdx
    pop rcx
    pop rbx
    ret
