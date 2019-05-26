[BITS 32]

print_pm:
    pusha
    mov edx, 0xb8000

.loop:
    mov al, [ebx]
    mov ah, 0x0f

    cmp al, 0
    je .done

    mov [edx], ax
    add ebx, 1
    add edx, 2
    jmp .loop

.done:
    popa
    ret