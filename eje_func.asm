
    ; 2 x ^ 4 -> x = 5
    ; cx limite inf. 
    ; val1 -> 03h
    ; val2 -> coeficiente # [n]*x^4
    ejecucionTermino4 macro val1, val2 
        multiplicacion_actualizarDatosEje_x cx, val1
        Push ax                 ; Guardo el valor del grado mas alto x^4
        toInt val2    ; convierto el coeficiente a numero
        mov bx, ax  ; bx -> 2            
        Pop ax      ; 5^4->625      
        mul bx      ; 625*2 = ax
        Pop cx ; sacamos el resultado de cx.            
    endm 



    ; Hace la potencia. x^n 
    multiplicacion_actualizarDatosEje_x macro number, times
        local cicloMultiplicar
        xor ax, ax
        xor bx, bx
        ; 2x^4 -> (5, 10) -> 
        mov ax, number ; 5
        mov bx, number ;5
        mov cx, times; 3
    ; 0...3 -> 5*5*5*5 = (5)^4
        cicloMultiplicar:
            mul bx
        Loop cicloMultiplicar
    endm



    ; 2x^3 -> x-> 2 = 2(2*2*2) = 16
    ; saca el resultado de la mult de n * x * x * x -> ax ? valuando 
    ejecucionTermino3 macro val1, val2 
        multiplicacion_actualizarDatosEje_x cx, val1
        neg ax                  ; niego el valor almacenado en 'ax'
        Push ax                 ; Guardo el valor del grado mas alto x^3
        toInt val2    
        mov bx, ax              
        Pop ax                  
        mul bx                  ; multiplico el coeficiente por el exponente
        Pop cx                  
    endm 



    movimientoDeTerminosExponentes macro 
        mov bx, ax ; necesito guardar el valor de ax. para operar nx3
        Pop ax  ; nx4
        add ax, bx ; AX = DX^4 + CX^3 + FX^3 + Ex
        Push ax                     ; guardo el valor de AX
        Push cx                   
    endm 




    popeo macro 
        Pop cx ;-> saca 5
        Push cx ;-> mete 5
        neg cx ; -5 -> 5 5 -> -5
        mul cx ; cx * ???
        Pop cx
    endm





    reestablecerValores macro
        mov bx, ax
        Pop cx ; el # que se esta valuando. 
        Pop ax ; AX = DX^4 + CX^3 + FX^3 + Ex + G = punto en el modo video
        add ax, bx
    endm




    reestablecerValoresMulValorCx macro 
        Pop cx                  
        Push cx
        mul cx                  
        Pop cx
    endm



    ; 159d 
    ; bx-> 159 
    ; 159 - 5 
    dibujarEje_x macro valor ;ejes x
        mov bx, valor
        sub bx, cx ; esto lo modifique
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


    ; val1 -> [n] x ^3 
    ; val2 -> [n] x ^2
    ; val3 -> [n] x
    ; val4 -> [n]
    guardarGrados_deLaFuncion macro val1, val2, val3, val4
        ejecucionTermino3 02h, val1  ;{***X3***}     guarda el valor de x^3 y multiplica el exponente por el coeficiente 2x^3 = 6x
        movimientoDeTerminosExponentes  ;reestablece el valor, bx=4x^4 + 3x^3

        ejecucionTermino4 01h, val2  ;{***X2***}     guarda el valor de x^2
        movimientoDeTerminosExponentes  ;reestablece el valor, bx=4x^4 + 3x^3
            
        toInt val3     ;{***X1***}     Convert the coefficient A x^1
        popeo                       ; se reestablece el valor de cx
        movimientoDeTerminosExponentes  ;Muevo el valor del coeficiente con exponente 'x^1 == Bx^1'  y  reestablezco el valor de 'ax' y lo almacena
            
        toInt val4 ;{***X0***} convierte el coeficiente E
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
        concatenar val1, val2, val3
        mov val1[si], 58h         ; X
        inc si
        mov val1[si], val4         ; recibo un caracter 
        inc si
    endm 
