include eje_func.asm
;*******************************************************************************
;					FUNCIONES UTILIZADAS PARA GRAFICAR 
;*******************************************************************************

    getOFunction macro string
        local coef4, coef3, coef2, coef1, coef0
        pushStack
        xor si, si
        concatenar string, msgFunctionM, SIZEOF msgFunctionM
                
        coef4:
            concatenar string, valueX4, SIZEOF valueX4
            mov string[si], 58h         ; X
            inc si
            mov string[si], 34h         ; 4
            inc si
        coef3:
            concatenacionFuncionText string, valueX3, SIZEOF valueX3, 33h
        coef2:
            concatenacionFuncionText string, valueX2, SIZEOF valueX2, 32h
        coef1:
            concatenacionFuncionText  string, valueX1, SIZEOF valueX1, 31h
        coef0:
            mov string[si], 2bh         ; +
            inc si
            concatenar string, valueX0, SIZEOF valueX0
        popStack
    endm








;*******************************************************************************
    GraphAxis macro
        local x_axis, y_axis
        mov cx, 13eh
        x_axis:
            printPixel cx, 63h, 4fh
        Loop x_axis
        mov cx, 0c6h
        y_axis:
            printPixel 9fh, cx, 4fh
        Loop y_axis
    endm



    GraphOriginalMacro macro inferior, superior
        local Follow, negativoLimiteInferior, PrintP,  cicloNumeroNegativo, cicloNumeroPositivo, pintar_x_negativo, NegativeXP, pintar_x_positivo, pintarNegativos, PositiveXP, finalizarCicloNegativo, finalizarCicloPositivo
        pushStack

        limpiarRegistros

        toInt inferior

        test ax, 1000000000000000b
            jnz negativoLimiteInferior
        jmp Follow

        negativoLimiteInferior:
            neg ax

        Follow:
        mov cx, ax

        ; -X
        cicloNumeroNegativo:
            Push cx  

            
            ejecucionTermino4 03h, valueX4  ;{***X4***}    guarda el valor de x^4 y multiplica el exponente por el coeficiente 2x^3 = 6x
            Push ax                 ; Save the value of DX^4
            Push cx                 ; Save the value of cx for the loop
            guardarGrados_deLaFuncion valueX3, valueX2, valueX1, valueX0


            test ax, 1000000000000000b
                jnz pintar_x_negativo
            jmp pintar_x_positivo

            pintar_x_negativo:
                para_ejes_negativo
                jmp pintarNegativos

            pintar_x_positivo:  ; Eje y
                mov dx, 63h
                sub dx, ax

            pintarNegativos:                
                cmp ax, 63h
                    jae finalizarCicloNegativo
                printPixel bx, dx, 4fh

            finalizarCicloNegativo:
        dec cx
            jne cicloNumeroNegativo


        toInt superior
        mov cx, ax

        ; +X
        cicloNumeroPositivo:
            Push cx 

            ejecucionTermino4 03h, valueX4  ; {***X4***}     Guarda el valor del grado 4
                Push ax 
                Push cx 
            ejecucionTermino4 02h, valueX3  ; {***X3***}     Guarda el valor del grado 3
            movimientoDeTerminosExponentes  ; Muevo el valor del grado 3 a 'bx'

            ejecucionTermino4 01h, valueX2  ; {***X2***}     Guarda el valor del grado 2
            movimientoDeTerminosExponentes  ; Muevo el valor del grado 2 a 'bx'
                        
            toInt valueX1         ; {***X1***} Convert the coefficient A x^1
                Pop cx
                mul cx

            movimientoDeTerminosExponentes  ; Muevo el valor del grado 1 a 'bx'
            toInt valueX0     ; {***X0***}     convierte el coeficiente E
            reestablecerValores
            
            ; ***********************Print pixels*********************
            dibujarEje_x_2

            test ax, 1000000000000000b
                jnz NegativeXP
            jmp PositiveXP

            NegativeXP:
                para_ejes_negativo
                jmp PrintP
            PositiveXP:
                ; Y axis
                mov dx, 63h
                sub dx, ax

            PrintP:                
                cmp ax, 63h
                    jae finalizarCicloPositivo
                printPixel bx, dx, 4fh


            finalizarCicloPositivo:
        dec cx
            jne cicloNumeroPositivo

        popStack
    endm



    GraphDerivedMacro macro inferior, superior
        local Follow, negativoLimiteInferior, cicloNumeroNegativo, cicloNumeroPositivo, pintar_x_negativo, pintar_x_positivo, pintarNegativos, NegativeXP, PositiveXP, PrintP, finalizarCicloNegativo, finalizarCicloPositivo
        pushStack

        limpiarRegistros

        toInt inferior

        test ax, 1000000000000000b
            jnz negativoLimiteInferior
        jmp Follow

        negativoLimiteInferior:
            neg ax

        Follow:
        mov cx, ax


        ; -X
        cicloNumeroNegativo:
            Push cx                         ; Save the value of cx

            ejecucionTermino3 02h, valueXD3     ; {***X3***}     Guarda el valor de grado 3
                Push ax
                Push cx
            ejecucionTermino4 01h, valueXD2     ; {***X2***}     Guarda el valor de grado 2
            movimientoDeTerminosExponentes

            toInt valueXD1            ; {***X1***}
            popeo
            movimientoDeTerminosExponentes      ; {***X1***}     Mueve el valor de grado 1 a 'bx'

            toInt valueXD0            ; {***X0***}
            reestablecerValores


            dibujarEje_x 9fh    ;159, +x
            test ax, 1000000000000000b
                jnz pintar_x_negativo
            jmp pintar_x_positivo

            pintar_x_negativo:
                para_ejes_negativo
                jmp pintarNegativos

            pintar_x_positivo:
                mov dx, 63h
                sub dx, ax

            pintarNegativos:
                cmp ax, 63h
                    jae finalizarCicloNegativo
                printPixel bx, dx, 4fh

            finalizarCicloNegativo:
        dec cx
            jne cicloNumeroNegativo

        toInt superior

        mov cx, ax

        ; +X
        cicloNumeroPositivo:
            Push cx                         ; Save the value of cx
            ejecucionTermino4 02h, valueXD3     ; {***X3***}    Guarda el valor de grado 3
                Push ax
                Push cx

            ejecucionTermino4 01h, valueXD2     ; {***X2***}
            movimientoDeTerminosExponentes

            toInt valueXD1            ; {***X1***}
            reestablecerValoresMulValorCx

            movimientoDeTerminosExponentes      ; Muevo el valor de bx^1 a 'bx'
            toInt valueXD0        ; {***X0***}
            reestablecerValores




            ; Print pixels. +x
            mov bx, 9fh
            add bx, cx

            test ax, 1000000000000000b
                jnz NegativeXP
            jmp PositiveXP

            NegativeXP:
                para_ejes_negativo
                jmp PrintP

            PositiveXP: ;pintar x positivo
                mov dx, 63h
                sub dx, ax

            PrintP:
                cmp ax, 63h
                    jae finalizarCicloPositivo
                printPixel bx, dx, 4fh

            finalizarCicloPositivo:
        dec cx
            jne cicloNumeroPositivo

        popStack
    endm



    GraphIntegralMacro macro inferior, superior
        local Follow, negativoLimiteInferior, cicloNumeroNegativo, cicloNumeroPositivo, pintar_x_negativo, pintar_x_positivo, pintarNegativos, NegativeXP, PositiveXP, PrintP, finalizarCicloNegativo, finalizarCicloPositivo
        pushStack

        limpiarRegistros

        toInt inferior

        test ax, 1000000000000000b
            jnz negativoLimiteInferior
        jmp Follow

        negativoLimiteInferior:
            neg ax

        Follow:
        mov cx, ax

        ; -X
        cicloNumeroNegativo:
            Push cx
            ejecucionTermino3 04h, valueXI5     ; {***X5***}
                Push ax
                Push cx
            ejecucionTermino4 03h, valueXI4     ; {***X4***}
            movimientoDeTerminosExponentes
            guardarGrados_deLaFuncion valueXI3, valueXI2, valueXI1, valueXI0    ; 3,2,1


            test ax, 1000000000000000b
                jnz pintar_x_negativo
            jmp pintar_x_positivo

            pintar_x_negativo:
                para_ejes_negativo
                jmp pintarNegativos

            pintar_x_positivo: ;pintar y+
                mov dx, 63h
                sub dx, ax
            
            pintarNegativos:
                cmp ax, 63h
                    jae finalizarCicloNegativo
                printPixel bx, dx, 4fh

            finalizarCicloNegativo:
        dec cx
            jne cicloNumeroNegativo
        

        toInt superior
        mov cx, ax

        ; +X
        cicloNumeroPositivo:
            Push cx            

            ; X5
            ejecucionTermino4 04h, valueXI5     ; {***X5***}
                Push ax
                Push cx

            ejecucionTermino4 03h, valueXI4     ; {***X4***}
            movimientoDeTerminosExponentes

            ejecucionTermino4 02h, valueXI3     ; {***X3***}
            movimientoDeTerminosExponentes

            ejecucionTermino4 01h, valueXI2     ; {***X2***}
            movimientoDeTerminosExponentes

            toInt valueXI1            ; {***X1***}
            reestablecerValoresMulValorCx

            movimientoDeTerminosExponentes
            toInt valueXI0            ; {***X0***}
            reestablecerValores

            ;************************* pintar ejes
            dibujarEje_x_2

            test ax, 1000000000000000b
                jnz NegativeXP
            jmp PositiveXP

            NegativeXP:
                para_ejes_negativo
                jmp PrintP

            PositiveXP:     ;eje y
                mov dx, 63h
                sub dx, ax
            
            PrintP:
                cmp ax, 63h
                    jae finalizarCicloPositivo
                printPixel bx, dx, 4fh

            finalizarCicloPositivo:
        dec cx
            jne cicloNumeroPositivo
        popStack
    endm



