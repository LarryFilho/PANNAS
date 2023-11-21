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

    dados db 5 dup(15,?,15 dup('?'),'?','?','?','?')
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

    lea dx,dados+2
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
    add si,17
volta:
    push dx
    lea dx,msg2
    PRINT_STRING
    pop dx

    push dx
    push bx
    push cx

    mov dl, 10  
    mov bl, 0         

inicio:

    mov ah, 01h
    int 21h

    cmp al, 13
    je  sair 

    mov ah, 0  
    sub al, 48
    jmp continua

jump_aux:
    jmp volta2

continua:
    mov cl, al
    mov al, bl

    mul dl

    add al, cl   
    mov bl, al

    jmp inicio    
sair:
    mov ax,bx
    pop cx
    pop bx
    pop dx
    mov dados[bx + si],al

    inc si
    dec cl
    jnz volta

    PULA_LINHA

    inc di
    mov cl,3
    xor si,si
    add bx,21
    lea dx, dados + bx
    dec ch
    jnz jump_aux
    
ret
input endp

print proc
    mov ch,5
    mov cl,3
    xor bx,bx
out_lop: 
    mov ah,09h
    int 21h
    inc si
    cmp dx,'?'
    jne out_lop
in_lop:

ret
print endp

end main