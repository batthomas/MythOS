[ORG 0x7c00]
[BITS 16]

main_rm:
    mov bx, MSG_RM
    call print_rm

    mov [BOOT_DRIVE], dl
    mov bp, 0x9000
    mov sp, bp

    mov bx, 0x1000
    mov dh, 2
    mov dl, [BOOT_DRIVE]
    call disk_load

    call switch_pm
    jmp $


%include "print_rm.asm"
%include "print_pm.asm"
%include "disk_sect.asm"
%include "switch_pm.asm"
%include "gdt.asm"


BOOT_DRIVE db 0
MSG_RM db "MythOS switched to Realmode", 0


[BITS 32]
main_pm:
    mov ebx, MSG_PM
    call print_pm
    call 0x1000
    jmp $


MSG_PM db "MythOS switched to Protected Mode", 0

times 510 - ($-$$) db 0
dw 0xaa55