limpiarVariables macro 
    mov valueX4, 0
    mov valueX3, 0
    mov valueX2, 0
    mov valueX1, 0
    mov valueX0, 0
endm

AnalyzeFile macro
LOCAL S0,S1,S2,S3,S4,S5,S6, salir, error, S_1, S_1X,NC, V4,V3,V2,fn,bgn
pushStack
xor si, si
xor di, di
xor al, al
xor bx,bx
; limpiarVariables
Clean varAux, sizeof varAux, 24h
S0:    
    limpiarVariables
    xor di, di
    Clean varAux, SIZEOF varAux, 24h
    mov al, bufferRead[si]
    printDebug estado0, al
    cmp al, 2bh; + 
    je S1

    cmp al, 2dh ; -
    je S1

    cmp al, 78h ;x
    je S3

    isDigit al
    cmp bl, 1
    je S2

    jmp error
S1:
    ; + | -
    printDebug estado1, al
    getChar
    mov varAux[di], al
    inc di
    inc si
    mov al, bufferRead[si]

    
    ; cmp al, 24h ;$
    ; je 

    cmp al, 78h ; x
    je S3

    isDigit al
    cmp bl, 1
    je S2

    jmp error

S2:
    mov varAux[di], al ; 5 | -5 | +5 
    inc di
    inc si

    printDebug estado2, al
    
    getChar
    mov al, bufferRead[si]
    

    isDigit al
    cmp bl, 1 ; mientras sea digito me quedo en este estado.
    je S2

    cmp al, 78h ; x
    je S3

    cmp al, 2bh; + 
    je S_1 ; acciones dentro del automata.

    cmp al, 2dh ; -
    je S_1

    cmp al, 59 ; ;
    je S6

    jmp error

S3: ; estoy reconociendo el termino x^n
    ; +x | -x | -5[x] | +5x | 10x
    printDebug estado3, al
    getChar
    inc si
    mov al, bufferRead[si]
    

    cmp al, 5eh ; ^
    je S4

    cmp al, 59 ; ;
    je S6

    cmp al, 2bh ; + 
    je S_1x

    cmp al, 2dh ; -
    je S_1x 

    cmp al, 24h
    je S6 ; probando esta parte.

S4:
    ; +x[^] | -10x[^]
    printDebug estado4, al
    ; getChar
    inc si 
    mov al, bufferRead[si]

    isDigit al

    ; printDebug estado4, bl
    ; getChar

    cmp bl, 1 ; 1 
    je S5

    jmp error

S5:
    ; -5x^[4] | 10x^3 | x^2
    printDebug estado5, al
    mov dh, varAux[0]
    cmp al, 4; ^4
    je V4
    ; jg error

    cmp al, 3 ; ^3
    je V3

    cmp al, 2 ; ^2 
    je V2
    ; jl error

    ;jmp error ; probar que pedo aqui. 

    V4:
        ; printDebug msgIt, dh
        ; mov valueX4, dh
        copyTo varAux, valueX4
        print newLine
        print valueX4
        jmp fn
    V3:
        printDebug msgIt, al
        ; mov valueX3, dh
        copyTo varAux, valueX3
        print newLine
        print valueX3
        jmp fn
    V2:
        printDebug msgIt, al
        ; mov valueX2, dh
        copyTo varAux, valueX2
        print newLine
        print valueX2
    fn:
        inc si
        mov al, bufferRead[si]
        
            ; borrar si falla
        xor di,di
        Clean varAux, sizeof varAux, 24h
        ; Lo de arribal. 


        printDebug msgIt, al
        cmp al, 59
        je S6 ; aqui debe finalizar

        cmp al, 2bh
        je S1
        cmp al, 2dh
        je S1

S6:
    ; printDebug estado6, al
    ; printDebug valueX4, al


    copyTo varAux, valueX0
    ; aqui deberia de tener todos los valores numericos
    print valueX4
    getChar
    ; print valueX3
    ; getChar
    ; print valueX2
    ; print valueX1
    print valueX0

    Clean functionToShow, SIZEOF functionToShow, 24h  ; limpia la variable de entrada de ecuacion
    mov valueX4, 37h
    mov valueX3, 36h
    mov valueX2, 35h
    mov valueX1, 39h
    mov valueX0, 38h

    getDFunction functionToShow
    ; getIFunction functionToShow

    print tab

    print functionToShow

    getChar


    ; inc si  
    ; mov al, bufferRead[si]
    incremento
    printDebug estado6, al
    cmp al, 24h ; $
    je salir

    xor di, di
    Clean varAux, SIZEOF varAux, 24h
    jmp S0

S_1X:
    ; -5x[+] | 10x- | x+ | -x+
    cmp varAux, 00h ; null
    je NC
    NC:
        mov varAux, 31h ; si X no tiene Coeficiente, lo asigno como 1
    
    mov bh, varAux
    mov valueX1, bh

    Clean varAux, sizeof varAux, 24h ; limpio varAux
    xor di, di ; limpio di para poder concatenar
    


    jmp S1

S_1:
    ; asignar el valor de varAux al coeficiente X0
    mov bh, varAux
    mov valueX0, bh ; muevo el valor de varAux al valuex0. 
    Clean varAux, sizeof varAux, 24h
    xor di, di ; necesito que se limpie di, para volver a concatenar desde 0
    incremento
    jmp S1 ; estoy seguro que reconoci alguna de las cadenas de abajo.
    ; 5[-] | -10+ | 10+ | 1-

error:
    ; parece que hay un error con la ecuacion.
    ; iterar hasta encontrar el ;
    printDebug msgError, al
    print newLine
    jmp salir

salir: 
    printDebug testing, al
    print newLine
    popStack
endm


incremento macro 
LOCAL inicio, while, fin

inicio:
    inc si
    mov al, bufferRead[si]
    cmp al, 20h
    jl while

    jmp fin
while:
    jmp inicio
fin:
endm

isDigit macro str
LOCAL inicio, fin, error
xor bl, bl
inicio:
    cmp str, 30h ; 0
    jl error

    cmp str, 39h ; 9  
    jg error


    mov bl, 1 ; lo intento usar como un flag
    jmp fin
error:
   mov bl, 0 

fin:
endm


printDebug macro msg, char
    push ax
    print newLine
    print msg
    mov ah, 02h
    mov dl, char
    int 21h
    pop ax
endm


copyTo macro source, dest
LOCAL while, fin
pushStack
xor si, si
xor di, di

while:
    mov al, source[si]
    cmp al, 24h ;$
    je fin

    mov dest[di], al

    inc si
    inc di
    jmp while

fin:
popStack
endm