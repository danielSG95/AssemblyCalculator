AnalyzeFile macro 
LOCAL S0,S1,S2,S3,S4,S5,S6, salir, error, S_1, S_1X,NC, V4,V3,V2,fn,bgn
pushStack
xor si, si
xor di, di
xor al, al
xor bx,bx
Clean varAux, sizeof varAux, 24h
S0:
    mov al, bufferRead[si]
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
    mov varAux[di], al
    inc di
    inc si
    mov al, bufferRead[si]
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

S3: ; estoy reconociendo el termino x^n
    ; +x | -x | -5[x] | +5x | 10x
    inc si
    mov al, bufferRead[si]

    cmp al, 5eh ; ^
    je S4

    cmp al, 3bh ; ;
    je S6

    cmp al, 2bh ; + 
    je S_1x

    cmp al, 2dh ; -
    je S_1x 

S4:
    ; +x[^] | -10x[^]
    inc si 
    mov al, bufferRead[si]

    isDigit al
    cmp bl, 31h ; 1 
    je S5

    jmp error

S5:
    ; -5x^[4] | 10x^3 | x^2
    mov varAux[di], al ; lo concateno para no perder el signo

    cmp al, 34h; ^4
    je V4
    jg error

    cmp al, 33h ; ^3
    je V3

    cmp al, 32h ; ^2 
    je V2
    jl error



    V4:
        mov valueX4, 34h
        jmp fn
    V3:
        mov valueX3, 33h
        jmp fn
    V2:
        mov valueX2, 32h
    fn:
        inc si
        mov al, bufferRead[si]
        cmp al, 3bh
        je S6 ; aqui debe finalizar

        cmp al, 2bh
        je S1
        cmp al, 2dh
        je S1

S6:
    ; aqui deberia de tener todos los valores numericos
    print valueX4
    print newLine
    print valueX3
    print newLine
    print valueX2
    print newLine
    print valueX1
    print newLine
    print valueX0

    inc si
    
    mov al, bufferRead[si]
    cmp al, 24h ; $
    jmp salir

    cmp al, 0ah ; \n
    je bgn

    bgn:
        inc si ; para asegurar que S0 inicie bien.
        xor di, di
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
    jmp S1 ; estoy seguro que reconoci alguna de las cadenas de abajo.
    ; 5[-] | -10+ | 10+ | 1-


error:
    ; parece que hay un error con la ecuacion.
    ; iterar hasta encontrar el ;
    print testing
    jmp salir

salir: 
    print saliendomsg
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