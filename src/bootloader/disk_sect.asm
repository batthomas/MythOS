disk_load:
    pusha
    push dx

    mov ah, 0x02 ; Read sectors from drive
    mov al, dh   ; Sectors to read count
    mov ch, 0x00 ; Cylinder number
    mov cl, 0x02 ; Sector number
    mov dh, 0x00 ; Head number

    int 0x13     ; Low-level disk services

    jc .disk_error
    pop dx
    cmp al, dh
    jne .sectors_error
    popa
    ret

.disk_error:
    mov bx, DISK_ERROR
    call print_rm
    jmp .loop

.sectors_error:
    mov bx, SECTORS_ERROR
    call print_rm
    jmp .loop

.loop:
    jmp $

DISK_ERROR: db "Disk read error", 0
SECTORS_ERROR: db "Incorrect number of sectors", 0