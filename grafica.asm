;*******************************************************************************
;					FUNCIONES UTILIZADAS PARA GRAFICAR 
;*******************************************************************************

    getOFunction macro string
        local X4, X3, X2, X1, X0
        Pushear
        xor si, si
        ConcatText string, msgFunctionM, SIZEOF msgFunctionM
                
        X4:
            ConcatText string, valueX4, SIZEOF valueX4
            mov string[si], 58h         ; X
            inc si
            mov string[si], 34h         ; 4
            inc si

        X3:
            concatenacionFuncionText string, valueX3, SIZEOF valueX3, 33h
            ;mov string[si], 2bh         ; +
            ;inc si
            ;ConcatText string, valueX3, SIZEOF valueX3
            ;mov string[si], 58h         ; X
            ;inc si
            ;mov string[si], 33h         ; 3
            ;inc si

        X2:
            concatenacionFuncionText string, valueX2, SIZEOF valueX2, 32h
            ;mov string[si], 2bh         ; +
            ;inc si
            ;ConcatText string, valueX2, SIZEOF valueX2
            ;mov string[si], 58h         ; X
            ;inc si
            ;mov string[si], 32h         ; 2
            ;inc si

        X1:
            concatenacionFuncionText  string, valueX1, SIZEOF valueX1, 31h
            ;mov string[si], 2bh         ; +
            ;inc si
            ;ConcatText string, valueX1, SIZEOF valueX1
            ;mov string[si], 58h         ; X
            ;inc si
            ;mov string[si], 31h         ; 1
            ;inc si

        X0:
            mov string[si], 2bh         ; +
            inc si
            ConcatText string, valueX0, SIZEOF valueX0

        Popear
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






    ejecucionTermino4 macro val1, val2 
        MultiplyXsTimes cx, val1
        Push ax                 ; Save the value of X^4
        ConvertToNumber val2 ; Convert the coefficient D x^4
        mov bx, ax              ; Move the result of the conversion to bx
        Pop ax                  ; Restore the value of ax
        mul bx                  ; Multiply by the coefficient the value of ax
        Pop cx                  ; Restore the value for the Loop                                (1)
    endm 

    ejecucionTermino3 macro val1, val2 
        MultiplyXsTimes cx, val1
        neg ax
        Push ax                 ; Save the value of X^3
        ConvertToNumber val2    ; Convert the coefficient C x^3
        mov bx, ax              ; Move the result of the conversion
        Pop ax                  ; Restore the value of ax
        mul bx                  ; Multiply by the coefficient the value of ax
        Pop cx                  ; Restore the value for the loop  
    endm 

    movimientoDeTerminosExponentes macro 
        mov bx, ax
        Pop ax                      ; Restore the value of ax
        add ax, bx                  ; AX = DX^4 + CX^3
        Push ax                     ; Save the value of DX^4 + CX^3
        Push cx                      ; Save the value of cx for the loop                            (3)
    endm 

    popeo macro 
        Pop cx
        Push cx
        neg cx
        mul cx
        Pop cx
    endm


    GraphOriginalMacro macro inferior, superior
        local Follow, NegativeInferior, RepeatNegative, RepeatPositive, NegativeXN, PositiveXN, PrintN, NegativeXP, PositiveXP, PrintP, EndOfLoopNeg, EndOfLoopPos
        Pushear

        xor si, si
        xor di, di
        xor ax, ax
        xor bx, bx
        xor cx, cx

        ConvertToNumber inferior

        test ax, 1000000000000000b
            jnz NegativeInferior
        jmp Follow

        NegativeInferior:
            neg ax

        Follow:
        mov cx, ax

        ; -X
        RepeatNegative:
            Push cx                 ; Save the value of cx                                              (1)

            ; X4
                ejecucionTermino4 03h, valueX4
                ;MultiplyXsTimes cx, 03h
                ;Push ax                 ; Save the value of X^4
                ;ConvertToNumber valueX4 ; Convert the coefficient D x^4
                ;mov bx, ax              ; Move the result of the conversion to bx
                ;Pop ax                  ; Restore the value of ax
                ;mul bx                  ; Multiply by the coefficient the value of ax
                ;Pop cx                  ; Restore the value for the Loop                                (1)
            
            Push ax                 ; Save the value of DX^4
            Push cx                 ; Save the value of cx for the loop                                 (2)
            
            ; X3
                ejecucionTermino3 02h, valueX3
                ;MultiplyXsTimes cx, 02h
                ;neg ax
                ;Push ax                 ; Save the value of X^3
                ;ConvertToNumber valueX3 ; Convert the coefficient C x^3
                ;mov bx, ax              ; Move the result of the conversion
                ;Pop ax                  ; Restore the value of ax
                ;mul bx                  ; Multiply by the coefficient the value of ax
                ;Pop cx                  ; Restore the value for the loop                                (2)

            ; Move the value of CX^3 to bx
            movimientoDeTerminosExponentes
            ;mov bx, ax
            ;Pop ax                      ; Restore the value of ax
            ;add ax, bx                  ; AX = DX^4 + CX^3
            ;Push ax                     ; Save the value of DX^4 + CX^3
            ;Push cx                      ; Save the value of cx for the loop                            (3)

            ; X2
                ejecucionTermino4 01h, valueX2
                ;MultiplyXsTimes cx, 01h
                ;Push ax                 ; Save the value of X^2
                ;ConvertToNumber valueX2 ; Convert the coefficient B x^2
                ;mov bx, ax              ; Move the result of the conversion to bx
                ;Pop ax                  ; Restore the value of ax
                ;mul bx                  ; Multiply by the coefficient the value of ax
                ;Pop cx                  ; Restore the value for the loop                                (3)

            ; Move the value of BX^2 to bx
            movimientoDeTerminosExponentes
            ;mov bx, ax
            ;Pop ax                      ; Restore the value of ax
            ;add ax, bx                  ; AX = DX^4 + CX^3 + BX^2
            ;Push ax                     ; Save the value of DX^4 + CX^3 + BX^2
            ;Push cx                      ; Save the value of cx for the loop                            (4)           
            
            ; X1
                ConvertToNumber valueX1 ; Convert the coefficient A x^1
                popeo
                ;Pop cx                  ; Restore the value of cx                                       (4)
                ;Push cx
                ;neg cx
                ;mul cx                  ; Multiply by the value of cx (x)
                ;Pop cx

            ; Move the value of AX^1 to bx
            movimientoDeTerminosExponentes
            ;mov bx, ax
            ;Pop ax                      ; Restore the value of ax
            ;add ax, bx                  ; AX = DX^4 + CX^3 + BX^2 + AX^1
            ;Push ax                     ; Save the value of ax
            ;Push cx                     ;                                                               (5)
            
            ; X0
                ConvertToNumber valueX0 ; Convert the coefficient E
                mov bx, ax
                Pop cx                  ;                                                               (5)
            
            Pop ax
            add ax, bx

            ; Print pixels
            ; X axis
            mov bx, 9fh
            sub bx, cx

            test ax, 1000000000000000b
                jnz NegativeXN
            jmp PositiveXN

            NegativeXN:
                neg ax
                ; Y axis
                mov dx, 63h
                add dx, ax
                jmp PrintN

            PositiveXN:
                ; Y axis
                mov dx, 63h
                sub dx, ax

            PrintN:                
                cmp ax, 63h
                    jae EndOfLoopNeg
                printPixel bx, dx, 4fh

            EndOfLoopNeg:
        dec cx
            jne RepeatNegative


        ConvertToNumber superior
        mov cx, ax

        ; +X
        RepeatPositive:
            Push cx                 ; Save the value of cx                                              (1)

            ; X4
                ejecucionTermino4 03h, valueX4
                ;MultiplyXsTimes cx, 03h
                ;Push ax                 ; Save the value of X^4
                ;ConvertToNumber valueX4 ; Convert the coefficient D x^4
                ;mov bx, ax              ; Move the result of the conversion to bx
                ;Pop ax                  ; Restore the value of ax
                ;mul bx                  ; Multiply by the coefficient the value of ax
                ;Pop cx                  ; Restore the value for the Loop                                (1)
            ;

            Push ax                 ; Save the value of DX^4
            Push cx                 ; Save the value of cx for the loop                                 (2)
            
            ; X3
                ejecucionTermino4 02h, valueX3
                ;MultiplyXsTimes cx, 02h
                ;Push ax                 ; Save the value of X^3
                ;ConvertToNumber valueX3 ; Convert the coefficient C x^3
                ;mov bx, ax              ; Move the result of the conversion
                ;Pop ax                  ; Restore the value of ax
                ;mul bx                  ; Multiply by the coefficient the value of ax
                ;Pop cx                  ; Restore the value for the loop                                (2)

            ; Move the value of CX^3 to bx
            movimientoDeTerminosExponentes
            ;mov bx, ax
            ;Pop ax                      ; Restore the value of ax
            ;add ax, bx                  ; AX = DX^4 + CX^3
            ;Push ax                     ; Save the value of DX^4 + CX^3
            ;Push cx                      ; Save the value of cx for the loop                            (3)

            ; X2
                ejecucionTermino4 01h, valueX2
                ;MultiplyXsTimes cx, 01h
                ;Push ax                 ; Save the value of X^2
                ;ConvertToNumber valueX2 ; Convert the coefficient B x^2
                ;mov bx, ax              ; Move the result of the conversion to bx
                ;Pop ax                  ; Restore the value of ax
                ;mul bx                  ; Multiply by the coefficient the value of ax
                ;Pop cx                  ; Restore the value for the loop                                (3)

            ; Move the value of BX^2 to bx
            movimientoDeTerminosExponentes
            ;mov bx, ax
            ;Pop ax                      ; Restore the value of ax
            ;add ax, bx                  ; AX = DX^4 + CX^3 + BX^2
            ;Push ax                     ; Save the value of DX^4 + CX^3 + BX^2
            ;Push cx                      ; Save the value of cx for the loop                            (4)           
            
            ; X1
                ConvertToNumber valueX1 ; Convert the coefficient A x^1
                Pop cx                  ; Restore the value of cx                                       (4)
                mul cx                  ; Multiply by the value of cx (x)

            ; Move the value of AX^1 to bx
            movimientoDeTerminosExponentes
            ;mov bx, ax
            ;Pop ax                      ; Restore the value of ax
            ;add ax, bx                  ; AX = DX^4 + CX^3 + BX^2 + AX^1
            ;Push ax                     ; Save the value of ax
            ;Push cx                     ;                                                               (5)
            
            ; X0
                ConvertToNumber valueX0 ; Convert the coefficient E
                mov bx, ax
                Pop cx                  ;                                                               (5)

            Pop ax
            add ax, bx            
            
            ; Print pixels
            ; X axis
            mov bx, 9fh
            add bx, cx

            test ax, 1000000000000000b
                jnz NegativeXP
            jmp PositiveXP

            NegativeXP:
                neg ax
                ; Y axis
                mov dx, 63h
                add dx, ax
                jmp PrintP
            PositiveXP:
                ; Y axis
                mov dx, 63h
                sub dx, ax

            PrintP:                
                cmp ax, 63h
                    jae EndOfLoopPos
                printPixel bx, dx, 4fh


            EndOfLoopPos:
        dec cx
            jne RepeatPositive

        Popear
    endm






    GraphDerivedMacro macro inferior, superior
        local Follow, NegativeInferior, RepeatNegative, RepeatPositive, NegativeXN, PositiveXN, PrintN, NegativeXP, PositiveXP, PrintP, EndOfLoopNeg, EndOfLoopPos
        Pushear

        xor si, si
        xor di, di
        xor ax, ax
        xor bx, bx
        xor cx, cx

        ConvertToNumber inferior

        test ax, 1000000000000000b
            jnz NegativeInferior
        jmp Follow

        NegativeInferior:
            neg ax

        Follow:
        mov cx, ax


        ; -X
        RepeatNegative:
            Push cx                         ; Save the value of cx

            ; X3
                ejecucionTermino3 02h, valueXD3
                ;MultiplyXsTimes cx, 02h
                ;neg ax
                ;Push ax                     ; Save the value of X^3
                ;ConvertToNumber valueXD3    ; Convert the coefficient C x^3
                ;mov bx, ax
                ;Pop ax
                ;mul bx                      ; Multiply by CX^3                
                ;Pop cx                      ; Restore the value for the loop
            
            Push ax
            Push cx

            ; X2
                ejecucionTermino4 01h, valueXD2
                ;MultiplyXsTimes cx, 01h
                ;Push ax
                ;ConvertToNumber valueXD2
                ;mov bx, ax
                ;Pop ax
                ;mul bx
                ;Pop cx

            movimientoDeTerminosExponentes
            ;mov bx, ax
            ;Pop ax
            ;add ax, bx
            ;Push ax
            ;Push cx

            ; X1
                ConvertToNumber valueXD1 
                popeo
                ;Pop cx                  
                ;Push cx
                ;neg cx
                ;mul cx                  
                ;Pop cx

            ; Move the value of AX^1 to bx
            movimientoDeTerminosExponentes
            ;mov bx, ax
            ;Pop ax                     
            ;add ax, bx                 
            ;Push ax                     
            ;Push cx     

            ; X0
                ConvertToNumber valueXD0
                mov bx, ax
                Pop cx                  

            Pop ax
            add ax, bx

            ; Print pixels
            ; X axis
            mov bx, 9fh
            sub bx, cx

            test ax, 1000000000000000b
                jnz NegativeXN
            jmp PositiveXN

            NegativeXN:
                neg ax
                ; Y axis
                mov dx, 63h
                add dx, ax
                jmp PrintN
            PositiveXN:
                ; Y axis
                mov dx, 63h
                sub dx, ax

            PrintN:
                cmp ax, 63h
                    jae EndOfLoopNeg
                printPixel bx, dx, 4fh

            EndOfLoopNeg:
        dec cx
            jne RepeatNegative

        ConvertToNumber superior

        mov cx, ax

        ; +X
        RepeatPositive:
            Push cx                         ; Save the value of cx

            ; X3
                ejecucionTermino4 02h, valueXD3
                ;MultiplyXsTimes cx, 02h
                ;Push ax                     ; Save the value of X^3
                ;ConvertToNumber valueXD3    ; Convert the coefficient C x^3
                ;mov bx, ax
                ;Pop ax
                ;mul bx                      ; Multiply by CX^3
                ;Pop cx                      ; Restore the value for the loop
            
            Push ax
            Push cx

            ; X2
                ejecucionTermino4 01h, valueXD2
                ;MultiplyXsTimes cx, 01h
                ;Push ax
                ;ConvertToNumber valueXD2
                ;Mov bx, ax
                ;Pop ax
                ;mul bx
                ;Pop cx

            movimientoDeTerminosExponentes
            ;mov bx, ax
            ;Pop ax
            ;add ax, bx
            ;Push ax
            ;Push cx

            ; X1
                ConvertToNumber valueXD1 
                Pop cx                  
                Push cx
                mul cx                  
                Pop cx

            ; Move the value of AX^1 to bx
            movimientoDeTerminosExponentes
            ;mov bx, ax
            ;Pop ax                    
            ;add ax, bx                 
            ;Push ax                     
            ;Push cx                     

            ; X0
                ConvertToNumber valueXD0 
                mov bx, ax
                Pop cx

            Pop ax
            add ax, bx

            ; Print pixels
            ; X axis
            mov bx, 9fh
            add bx, cx

            test ax, 1000000000000000b
                jnz NegativeXP
            jmp PositiveXP

            NegativeXP:
                neg ax
                ; Y axis
                mov dx, 63h
                add dx, ax
                jmp PrintP
            PositiveXP:
                ; Y axis
                mov dx, 63h
                sub dx, ax

            PrintP:
                cmp ax, 63h
                    jae EndOfLoopPos
                printPixel bx, dx, 4fh

            EndOfLoopPos:
        dec cx
            jne RepeatPositive

        Popear
    endm





    GraphIntegralMacro macro inferior, superior
        local Follow, NegativeInferior, RepeatNegative, RepeatPositive, NegativeXN, PositiveXN, PrintN, NegativeXP, PositiveXP, PrintP, EndOfLoopNeg, EndOfLoopPos
        Pushear

        xor si, si
        xor di, di
        xor ax, ax
        xor bx, bx
        xor cx, cx

        ConvertToNumber inferior

        test ax, 1000000000000000b
            jnz NegativeInferior
        jmp Follow

        NegativeInferior:
            neg ax

        Follow:
        mov cx, ax

        ; -X
        RepeatNegative:
            Push cx

            ; X5
                ejecucionTermino3 04h, valueXI5
                ;MultiplyXsTimes cx, 04h
                ;neg ax
                ;Push ax
                ;ConvertToNumber valueXI5
                ;mov bx, ax
                ;Pop ax
                ;mul bx
                ;Pop cx

            Push ax
            Push cx

            ; X4
                ejecucionTermino4 03h, valueXI4
                ;MultiplyXsTimes cx, 03h
                ;Push ax
                ;ConvertToNumber valueXI4
                ;mov bx, ax
                ;Pop ax
                ;mul bx
                ;Pop cx

            movimientoDeTerminosExponentes
            ;mov bx, ax
            ;Pop ax
            ;add ax, bx
            ;Push ax
            ;Push cx

            ; X3
                ejecucionTermino3 02h, valueXI3
                ;MultiplyXsTimes cx, 02h
                ;neg ax
                ;Push ax
                ;ConvertToNumber valueXI3
                ;mov bx, ax
                ;Pop ax
                ;mul bx
                ;Pop cx

            movimientoDeTerminosExponentes
            ;mov bx, ax
            ;Pop ax
            ;add ax, bx
            ;Push ax
            ;Push cx

            ; X2
                ejecucionTermino4 01h, valueXI2
                ;MultiplyXsTimes cx, 01h
                ;Push ax
                ;ConvertToNumber valueXI2
                ;mov bx, ax
                ;Pop ax
                ;mul bx
                ;Pop cx

            movimientoDeTerminosExponentes
            ;mov bx, ax
            ;Pop ax
            ;add ax, bx
            ;Push ax
            ;Push cx

            ; X1
                ConvertToNumber valueXI1
                popeo
                ;Pop cx
                ;Push cx
                ;neg cx
                ;mul cx
                ;Pop cx

            movimientoDeTerminosExponentes
            ;mov bx, ax
            ;Pop ax
            ;add ax, bx
            ;Push ax
            ;Push cx

            ; XO
                ConvertToNumber valueXI0
                mov bx, ax
                Pop cx

            Pop ax
            add ax, bx

            ; Print pixels

            ; X axis
            mov bx, 9fh
            sub bx, cx

            test ax, 1000000000000000b
                jnz NegativeXN
            jmp PositiveXN

            NegativeXN:
                neg ax
                ; Y axis
                mov dx, 63h
                add dx, ax
                jmp PrintN
            PositiveXN:
                ; Y axis
                mov dx, 63h
                sub dx, ax
            
            PrintN:
                cmp ax, 63h
                    jae EndOfLoopNeg
                printPixel bx, dx, 4fh

            EndOfLoopNeg:
        dec cx
            jne RepeatNegative
        

        ConvertToNumber superior
        mov cx, ax

        ; +X
        RepeatPositive:
            Push cx            

            ; X5
                ejecucionTermino4 04h, valueXI5
                ;MultiplyXsTimes cx, 04h
                ;Push ax
                ;ConvertToNumber valueXI5
                ;mov bx, ax
                ;Pop ax
                ;mul bx
                ;Pop cx

            Push ax
            Push cx

            ; X4
                ejecucionTermino4 03h, valueXI4
                ;MultiplyXsTimes cx, 03h
                ;Push ax
                ;ConvertToNumber valueXI4
                ;mov bx, ax
                ;Pop ax
                ;mul bx
                ;Pop cx

            movimientoDeTerminosExponentes
            ;mov bx, ax
            ;Pop ax
            ;add ax, bx
            ;Push ax
            ;Push cx

            ; X3
                ejecucionTermino4 02h, valueXI3
                ;MultiplyXsTimes cx, 02h
                ;Push ax
                ;ConvertToNumber valueXI3
                ;mov bx, ax
                ;Pop ax
                ;mul bx
                ;Pop cx

            movimientoDeTerminosExponentes
            ;mov bx, ax
            ;Pop ax
            ;add ax, bx
            ;Push ax
            ;Push cx

            ; X2
                ejecucionTermino4 01h, valueXI2
                ;MultiplyXsTimes cx, 01h
                ;Push ax
                ;ConvertToNumber valueXI2
                ;mov bx, ax
                ;Pop ax
                ;mul bx
                ;Pop cx

            movimientoDeTerminosExponentes
            ;mov bx, ax
            ;Pop ax
            ;add ax, bx
            ;Push ax
            ;Push cx

            ; X1
                ConvertToNumber valueXI1
                Pop cx
                Push cx
                mul cx
                Pop cx

            movimientoDeTerminosExponentes
            ;mov bx, ax
            ;Pop ax
            ;add ax, bx
            ;Push ax
            ;Push cx

            ; XO
                ConvertToNumber valueXI0
                mov bx, ax
                Pop cx

            Pop ax
            add ax, bx

            ; Print pixels

            ; X axis
            mov bx, 9fh
            add bx, cx

            test ax, 1000000000000000b
                jnz NegativeXP
            jmp PositiveXP

            NegativeXP:
                neg ax
                ; Y axis
                mov dx, 63h
                add dx, ax
                jmp PrintP
            PositiveXP:
                ; Y axis
                mov dx, 63h
                sub dx, ax
            
            PrintP:
                cmp ax, 63h
                    jae EndOfLoopPos
                printPixel bx, dx, 4fh

            EndOfLoopPos:
        dec cx
            jne RepeatPositive
        Popear
    endm




    MultiplyXsTimes macro number, times
        local RepeatMultiply

        xor ax, ax
        xor bx, bx

        mov ax, number
        mov bx, number
        mov cx, times

        RepeatMultiply:
            mul bx
        Loop RepeatMultiply        

    endm

