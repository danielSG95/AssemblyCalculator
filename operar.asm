;*******************************************************************************
;					FUNCIONES UTILIZADAS PARA REALIZAR DERIVADAS 
;*******************************************************************************

    ; 4x... <- imprimir en pantalla. 
    getDFunction macro string
        local X3, X2, X1, X0
        pushStack
        xor si, si

        concatenar string, msgDerived, SIZEOF msgDerived

        ; X4 -> X3
        X3:
            conversion_a_numero valueX4, 04h, valueXD3
            concatenar string, valueXD3, SIZEOF valueXD3
            almacenarDatos_equisExp string, 58h, 33h    ;x,3

        ; X3 -> X2
        X2:
            conversion_a_numero valueX3, 03h, valueXD2
            mov string[si], 2bh         ; +
            inc si
            concatenar string, valueXD2, SIZEOF valueXD2
            almacenarDatos_equisExp string, 58h, 32h    ;x,2

        ; X2 -> X1
        X1:
            conversion_a_numero valueX2, 02h, valueXD1
            mov string[si], 2bh         ; +
            inc si
            concatenar string, valueXD1, SIZEOF valueXD1
            almacenarDatos_equisExp string, 58h, 31h    ;x,1
        
        ; X1 -> X0
        X0:
            toInt valueX1     ; Value in ax        
            toString valueXD0
            mov string[si], 2bh         ; +
            inc si
            concatenar string, valueXD0, SIZEOF valueXD0

        popStack
    endm




    conversion_a_numero macro val1, val2, val3
        toInt val1     ; Value in ax        
        mov bx, val2
        mul bx
        toString val3
    endm 


    ;almacena de esto: x^2 esto = x 2
    almacenarDatos_equisExp macro vec, carac1, carac2
        mov vec[si], carac1         ; X
        inc si
        mov vec[si], carac2         ; 1
        inc si
    endm 




;*******************************************************************************
;					FUNCIONES UTILIZADAS PARA REALIZAR INTEGRALES 
;*******************************************************************************

    getIFunction macro string
        local X5, negativoGrado5, sigExpGrado5, X4, negativoGrado4, sigExpGrado4, X3, negativoGrado3, sigExpGrado3, X2, negativoGrado2, sigExpGrado2, X1, X0
        pushStack
        xor si, si
        concatenar string, msgIntegral, SIZEOF msgIntegral

        ; Los siguientes x# se aumenta el exponente debido los cambios que sufre la integral x4=>x5, x3=x4, etc...
        X5:
            toInt valueX4
            xor di, di
            test ax, 1000000000000000b
                jnz negativoGrado5
            jmp sigExpGrado5

            negativoGrado5:
                neg ax
            
			sigExpGrado5:
                mov bl, 05h
                div bl

            toString valueXI5
            concatenar string, valueX4, SIZEOF valueX4
            realizoDegradoExponente string, 35h, 35h    ;5,5

        
        X4:
            mov string[si], 2bh         ; +
            inc si
            toInt valueX3
            test ax, 1000000000000000b
                jnz negativoGrado4
            jmp sigExpGrado4
            
			negativoGrado4:
                neg ax
            
			sigExpGrado4:
                capturaSiguientes_exp string, 04h, valueXI4, valueX3, 34h;4,4

        
        X3:
            mov string[si], 2bh         ; +
            inc si
            toInt valueX2
            test ax, 1000000000000000b
                jnz negativoGrado3
            jmp sigExpGrado3
            
            negativoGrado3:
                neg ax
           
		    sigExpGrado3:
                capturaSiguientes_exp string, 03h, valueXI3, valueX2, 33h;3,3

        
        X2:
            mov string[si], 2bh         ; +
            inc si
            toInt valueX1
            test ax, 1000000000000000b
                jnz negativoGrado2
            jmp sigExpGrado2
            
            negativoGrado2:
                neg ax
            sigExpGrado2:
                capturaSiguientes_exp string, 02h, valueXI2, valueX1, 32h;2,2


        
        X1:
            mov string[si], 2bh         ; +
            inc si
            toInt valueX0
            toString valueXI1
            concatenar string, valueX0, SIZEOF valueX0
            mov string[si], 58h             ; X
            inc si
            mov string[si], 31h             ; 1
            inc si


        ; +C
        X0:
            concatenar string, msgC, SIZEOF msgC

        popStack
    endm


    ;metodos varios
    capturaSiguientes_exp macro string, val1, val2, val3, val4
        division val1
        toString val2    
        concatenar string, val3, SIZEOF val3    ;concatena la ecuacion a formar
        realizoDegradoExponente string, val4, val4 ;caputra numero 2,2 ; 3,3 et..
    endm



    ; AX^4  ==  (A/4)X^3
    realizoDegradoExponente macro vec, c1, c2 
        mov vec[si], 2fh     ; /
        inc si
        mov vec[si], c1      ; valor numerico
        inc si
        mov vec[si], 58h     ; X
        inc si
        mov vec[si], c2      ; valor numerico exponencial
        inc si
    endm

    division macro c1
        mov bl, c1
        div bl
        xor ah, ah
    endm 