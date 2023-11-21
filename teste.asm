.model small

    PULA_LINHA MACRO
        push dx
        push ax

        mov dl,10
        mov ah,02
        int 21h

        pop ax
        pop dx
    endm

    PRINT_STRING MACRO
        push ax
        push dx

        mov ah,09
        int 21h

        mov dx,di
        mov ah,02
        int 21h

        mov dl,':'
        mov ah,02
        int 21h

        pop dx
        pop ax
    endm



.stack 100h
.data

    dados db 5 dup(15,?,15 dup('?'),0,0,0,0)
          ;db 1 dup(15,?,15 dup('$')),'?','?','?','?'
          ;b 1 dup(15,?,15 dup('$')),'?','?','?','?'
          ;db 1 dup(15,?,15 dup('$')),'?','?','?','?'
          ;db 1 dup(15,?,15 dup('$')),'?','?','?','?'

    msg1 db 10,13,'DIGITE NOME DO ALUNO $'

    msg2 db 10,13,'DIGITE NOTA DO ALUNO $'


.code

main proc
    mov ax,@data
    mov ds,ax
    mov es,ax

    lea dx,dados[bx + si]
    call input
    
    xor bx,bx
    xor si,si

    lea dx,dados[bx][si]
    call print

    mov ah,4ch
    int 21h
main endp

input proc

    mov ch,5
    mov cl,3
    mov di,49
volta2:
    push dx
    push bx
    lea dx,msg1
    PRINT_STRING
    pop bx
    pop dx

    mov ah,0ah
    int 21h
volta:
    add si,17
    push dx
    lea dx,msg2
    PRINT_STRING
    pop dx

push bx
xor bx,bx
jesus:
    mov ah,01h
    int 21h
    sub al,30h
    cmp al,13
    je sair
    mov ah,00h
    rol bx,1
    add bx,ax
    jmp jesus
sair:
    pop bx
    mov dados[bx + si],al

    dec cl
    jnz volta

    PULA_LINHA

    inc di
    mov cl,3
    xor si,si
    add bx,21
    dec ch
    jnz volta2

ret
input endp

print proc

    mov ch,5
    mov cl,4
volta3:
    mov ah,09
    int 21h

    push dx
    push ax
    mov dl,' '
    mov ah,02
    int 21
    pop ax
    pop dx

    inc SI
    dec cl
    jnz volta3

    PULA_LINHA

    mov cl,4
    xor si,si
    add bx,17
    dec ch
    jnz volta3
ret
print endp
end main