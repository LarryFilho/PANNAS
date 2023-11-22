.model small

    PULA_LINHA MACRO
        push dx
        push ax

        mov dl,10
        mov ah,02
        int 21h

        mov dl,13
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

    LIMPAENTER MACRO
        PUSH BX
        PUSH DX

        INC BX
        MOV DL, [BX]
        INC BX
        ADD BX, DX
        MOV DL, ' '

        MOV [BX], DL
        
        POP DX
        POP BX
    ENDM

    PRINT_ESPACO MACRO
        push bx
        push dx
        push cx

        mov cx,2
    espa:    
        mov dl, ' '
        mov ah,02
        int 21H
        loop espa

        pop cx
        pop dx
        pop bx
    endm

    input_numero macro
        push ax
        push bx
        push cx
        push dx

        mov bl,10
    comeco:
        mov ah, 01h
        int 21h

        cmp al, 13
        je  final 

        mov ah, 0  
        sub al, 48

        mov cl, al
        mov al, bl

        mul dl

        add al, cl   ; previous value + new value ( after previous value is multiplyed with 10 )
        mov bl, al

        jmp comeco    

        final:
        pop dx
        pop cx
        pop dx
        pop ax
        endm

.stack 100h
.data
            
    dados  db 5 dup(15,?,15 dup('?'),'?','?','?','?')
          ;db 1 dup(15,?,15 dup('$')),'?','?','?','?'
          ;b 1 dup(15,?,15 dup('$')),'?','?','?','?'
          ;db 1 dup(15,?,15 dup('$')),'?','?','?','?'
          ;db 1 dup(15,?,15 dup('$')),'?','?','?','?'

    msg1 db 10,13,'DIGITE NOME DO ALUNO $'

    msg2 db 10,13,'DIGITE NOTA DO ALUNO $'

    LEGENDA DB 'NOME',12 DUP (' '),'P1 ','P2 ','P3 ', 'MF$'

    msg3 db 10,13,'QUAL AUNO DESEJA ALTERAR A NOTA:$'

    msg4 db 10,13,'DIGITE A NOVA NOTA:$'

    BUFFER db 5 dup(15,?,15 dup('?'),'?','?','?','?')

    FFLUSH DB 15 DUP(' ')

    msg5 db 10,13,'NOME INVALIDO!!$'

    msg6 db 10,13,'QUAL PROVA DESEJA ALTERAR:$'

    msg7 db 10,13,'P1-1   P2-2   P3-3$'


.code

main proc
    mov ax,@data
    mov ds,ax
    mov es,ax

    lea dx,dados[bx + si]
    call input

    mov si,2
    call print

cont_main:

    lea dx,msg3
    mov ah,09
    int 21h

    xor bx,bx
    xor si,si

    lea dx,BUFFER

    call compara_string

cont_main2:
    lea dx,dados
    call print
fim:
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
        LIMPAENTER
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
        xor di,di
        xor cx,cx
        mov ch, 5
        mov bx,2
        mov di,17
        push bx
        push di
        lea dx, LEGENDA
        PRINT_STRING
        PULA_LINHA
    teste:
        mov dl, dados + bx
        cmp dx,'?'
        je sair2

        mov ah,02
        int 21h
        inc bx
        inc cl
        jmp teste
    sair2:
        mov bh,15
        dec cl
        sub bh,cl
    lope:
        mov dl,' '
        mov ah,02
        int 21H
        dec bh
        jnz lope
    lop:
        mov dl, dados + di
        cmp dx,'?'
        je algum

        add dl,30h
        mov ah,02
        int 21h

    PRINT_ESPACO

        inc di
        jmp lop

    algum:
        PULA_LINHA
        pop di
        pop bx
        add bx,21
        add di,21
        push bx
        push di
        mov cl,00h
        dec ch
        jnz teste

        pop di
        pop bx
ret
print endp

compara_string proc

    mov ah,0ah
    int 21h

    lea bx, BUFFER

    mov dx,[bx + 1]
    mov dh,00h

    mov bx, dx
    mov ch, bl
    mov cl,1

    lea si,dados + 2
    lea di,buffer + 2      
volta3:
    cmp ch,0
    jz correto
    mov dx,[si]
    mov bx,[di]

    mov dh,00h
    mov bh,00h

    cmp dx,bx
    jnz diferente
    inc si
    inc di
    dec ch
    jmp volta3

diferente:
    xor ax,ax
    push cx
    mov al,21
    mul cl
    mov ch,00h
    lea si, dados + 2    
    add si,cx
    lea di, buffer +2
    add di,cx
    pop cx
    inc cl

correto:
    PULA_LINHA

    lea dx,msg7
    mov ah,09
    int 21h

    lea dx,msg6
    mov ah,09
    int 21h

    mov ah, 01h
    int 21h

    PULA_LINHA

    xor dx,dx

    sub al,30h
    mov dl,al
    dec dl

    xor ax,ax
    push cx

    mov al,17
    mul cl
    mov ch,00h
    lea si, dados
    add si,ax
    add si,dx
    lea di, buffer
    add di,ax
    add di,dx
    
    pop cx
    inc cl

    lea dx,msg4
    mov ah,09
    int 21h

    mov dl,10
    mov bl,0
    comeco3:
        mov ah, 01h
        int 21h

        cmp al, 13
        je  final3 

        mov ah, 0  
        sub al, 48

        mov cl, al
        mov al, bl

        mul dl

        add al, cl   ; previous value + new value ( after previous value is multiplyed with 10 )
        mov bl, al

        jmp comeco3   

    final3:

    mov [si],bx
ret
compara_string endp

end main