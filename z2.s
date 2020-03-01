global _start

section .bss
    buffer resb 4
    num resb 3
    counter resb 1

section .data
    space db 32
    nl db 10

section .text
exit:
    mov eax, 1
    mov ebx, 0
    int 0x80

getInt:
    mov eax, 0
    mov ebx, buffer
        whileNumsToRead:
            mov ecx, [ebx]
            cmp cl, 10
            jne dont_ret
                ret
            dont_ret:
                mov edx, 10
                mul edx
                add eax, ecx
                sub eax, 48
                inc ebx
                jmp whileNumsToRead

displayRow:
    push eax
    push ecx
    
    mov [counter], byte 0
    mov [num], byte 48
    mov [num+1], byte 48
    mov [num+2], byte 49

    write:
        inc byte [counter]

        displayFirst:
        cmp [num], byte 48
        je checkSecond
            mov eax, 4
            mov ebx, 1
            mov ecx, num
            mov edx, 1
            int 0x80

            jmp displaySecond

        checkSecond:
        cmp [num+1], byte 48
        je displayThird
            displaySecond: 
                mov eax, 4
                mov ebx, 1
                mov ecx, num+1
                mov edx, 1
                int 0x80

                cmp [num+1], byte 58
                jl displayThird
                    mov [num+1], byte 48
                    inc byte [num]

        displayThird:
            mov eax, 4
            mov ebx, 1
            mov ecx, num+2
            mov edx, 1
            int 0x80

            inc byte [num+2]

            cmp [num+2], byte 58
            jl skip
                mov [num+2], byte 48
                inc byte [num+1]

        skip:
        mov eax, 4
        mov ebx, 1
        mov ecx, space
        mov edx, 1
        int 0x80

        mov cl, byte [esp]
        cmp [counter], cl
        jb write

        mov eax, 4
        mov ebx, 1
        mov ecx, nl
        mov edx, 1
        int 0x80

    jmp whileRowsToDisplay

_start:
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 4
    int 0x80

    call getInt

    mov ecx, 0
    push eax
    push ecx
    whileRowsToDisplay:
        pop ecx
        pop eax

        cmp cl, al
        inc cl
        jb displayRow
            jmp exit