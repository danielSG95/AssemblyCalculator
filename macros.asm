 ; Inprimir en pantalla
print macro string
    pushStack
    mov ah, 09h
    mov dx, offset string
    int 21h
    popStack
endm

; Obtiene un caracter de teclado
getChar macro    
    mov ah, 01h
    int 21h
endm

; Limpia un array
Clean macro string, numBytes, char
    local while
    pushStack
    xor si, si
    xor cx, cx
    mov cx, numBytes
    while:
        mov string[si], char
        inc si
    Loop while
    popStack
endm

; Obtener cadena
getText macro string
    local getCharacter, fin, Backspace
    xor si, si
    xor ax, ax
    getCharacter:
        getChar
        cmp al, 0dh
            je fin
        cmp al, 08h
            je Backspace
        mov string[si], al
        inc si
        jmp getCharacter
    Backspace:
        mov al, 24h
        dec si
        mov string[si], al
        jmp getCharacter
    fin:        
        mov al, 24h
        mov string[si], al
endm

moveCursor macro row, column
    pushStack
    mov ah, 02h
    mov dh, row
    mov dl, column
    int 10h
    popStack
endm

; Limpia la pantalla
clr macro
    local while
    pushStack
    mov dx, 50h
    while:
        print newLine
    Loop while
    moveCursor 00h, 00h
    popStack
endm

; pinta un pixel en la pantalla
printPixel macro x, y, color
    pushStack

    mov ah, 0ch
    mov al, color
    mov bh, 0h
    mov dx, y
    mov cx, x

    int 10h

    popStack
endm

; concatena str2 en str1
concatenar macro str1, str2, numBytes
    local while, fin

    xor di, di
    mov cx, numBytes
    while:
        mov al, str2[di]
        cmp al, 24h
            je fin
        inc di
        mov str1[si], al
        inc si
    Loop while
    fin:
endm

;*****************************************************
; *******************CONVERSIONES*********************
;*****************************************************

    toInt macro string
        local inicio, fin, positivo, negativo, negar
        Push si
        
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        mov bx, 10
        xor si, si
        xor di, di
        inicio:
            mov cl, string[si]      
            cmp cl, '+'
                je positivo
            cmp cl, '-'
                je negativo
            cmp cl, 48
                jl fin
            cmp cl, 57
                jg fin
            inc si
            sub cl, 48  ; resta 48 para obtener el numero decimal
            mul bx      ; Se multiplica por 10 para obtener decenas/centenas, etc
            add ax, cx

            jmp inicio
        positivo:
            inc si
            jmp inicio
        negativo:
            inc di            
            inc si
            jmp inicio
        negar:
            xor di, di
            neg ax
            xor dx, dx
        fin:        
            cmp di, 01h
                je negar
            Pop si
    endm

    toString macro string
        local Divide, Divide2, EndCr3, negar, End2, fin
        Push si
        xor si, si
        xor cx, cx
        xor bx, bx
        xor dx, dx
        mov dl, 0ah
        test ax, 1000000000000000b
            jnz negar
        jmp Divide2
        negar:
            neg ax
            mov string[si], 45
            inc si
            jmp Divide2
        
        Divide:
            xor ah, ah
        Divide2:
            div dl
            inc cx
            Push ax
            cmp al, 00h ; null
                je EndCr3
            jmp Divide
        EndCr3:
            pop ax
            add ah, 30h ; 0
            mov string[si], ah
            inc si
        Loop EndCr3
        mov ah, 24h
        mov string[si], ah
        inc si
        fin:
            Pop si
    endm

;*****************************************************
;RECOVER THINGS 
;*****************************************************

    pushStack macro
        push ax
        push bx
        push cx
        push dx
        push si
        push di
    endm

    popStack macro                    
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
    endm

;***********************************************
;************MANEJO DE ARCHIVOS*****************
;***********************************************

_openFile macro name, handler 
print name
mov ah, 3dh
mov al, 010b
lea dx, name
int 21h
jc errorOpeningFile
mov handler, ax
endm

_closeFile macro handler
mov ah, 3eh
mov bx, handler
int 21h
jc errorClosingFile
endm

_readFile macro handler, buffer, size
mov ah, 3fh 
mov bx, handler
mov cx, size
lea dx, buffer
int 21h 
jc errorReadingFile
endm