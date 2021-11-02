


    ejecucionTermino4 macro val1, val2 
        multiplicacion_actualizarDatosEje_x cx, val1
        Push ax                 ; Guardo el valor del grado mas alto x^4
        ConvertToNumber val2    ; convierto el coeficiente a numero
        mov bx, ax              
        Pop ax            
        mul bx                  ; multiplico el coeficiente por el exponente
        Pop cx            
    endm 




    multiplicacion_actualizarDatosEje_x macro number, times
        local cicloMultiplicar
        xor ax, ax
        xor bx, bx

        mov ax, number
        mov bx, number
        mov cx, times

        cicloMultiplicar:
            mul bx
        Loop cicloMultiplicar
    endm





    ejecucionTermino3 macro val1, val2 
        multiplicacion_actualizarDatosEje_x cx, val1
        neg ax                  ; niego el valor almacenado en 'ax'
        Push ax                 ; Guardo el valor del grado mas alto x^3
        ConvertToNumber val2    
        mov bx, ax              
        Pop ax                  
        mul bx                  ; multiplico el coeficiente por el exponente
        Pop cx                  
    endm 



    movimientoDeTerminosExponentes macro 
        mov bx, ax
        Pop ax                      ; reestablecer el valor de 'ax'
        add ax, bx                  ; AX = DX^4 + CX^3
        Push ax                     ; guardo el valor de AX
        Push cx                   
    endm 




    popeo macro 
        Pop cx
        Push cx
        neg cx
        mul cx
        Pop cx
    endm





    reestablecerValores macro
        mov bx, ax
        Pop cx
        Pop ax
        add ax, bx
    endm




    reestablecerValoresMulValorCx macro 
        Pop cx                  
        Push cx
        mul cx                  
        Pop cx
    endm




    dibujarEje_x macro valor ;ejes x
        mov bx, valor
        sub bx, cx
    endm




    dibujarEje_x_2 macro valor ;ejes x
        mov bx, 9fh
        add bx, cx
    endm




    para_ejes_negativo macro ;ejes y
        neg ax
        mov dx, 63h
        add dx, ax
    endm



    guardarGrados_deLaFuncion macro val1, val2, val3, val4
        ejecucionTermino3 02h, val1  ;{***X3***}     guarda el valor de x^3 y multiplica el exponente por el coeficiente 2x^3 = 6x
        movimientoDeTerminosExponentes  ;reestablece el valor, bx=4x^4 + 3x^3

        ejecucionTermino4 01h, val2  ;{***X2***}     guarda el valor de x^2
        movimientoDeTerminosExponentes  ;reestablece el valor, bx=4x^4 + 3x^3
            
        ConvertToNumber val3     ;{***X1***}     Convert the coefficient A x^1
        popeo                       ; se reestablece el valor de cx
        movimientoDeTerminosExponentes  ;Muevo el valor del coeficiente con exponente 'x^1 == Bx^1'  y  reestablezco el valor de 'ax' y lo almacena
            
        ConvertToNumber val4 ;{***X0***} convierte el coeficiente E
        reestablecerValores

        ; ********************   Print pixels   ***********************
        dibujarEje_x 9fh    ;159, +x
    endm




    limpiarRegistros macro 
        xor si, si
        xor di, di
        xor ax, ax
        xor bx, bx
        xor cx, cx
    endm



    
    concatenacionFuncionText macro val1, val2, val3, val4
        mov val1[si], 2bh         ; +
        inc si
        ConcatText val1, val2, val3
        mov val1[si], 58h         ; X
        inc si
        mov val1[si], val4         ; recibo un caracter 
        inc si
    endm 
