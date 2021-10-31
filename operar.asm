;*******************************************************************************
;					FUNCIONES UTILIZADAS PARA REALIZAR DERIVADAS 
;*******************************************************************************


    getDFunction macro string
        local X3, X2, X1, X0
        Pushear
        xor si, si

        ConcatText string, msgDerived, SIZEOF msgDerived

        ; X4 -> X3
        X3:
            ConvertToNumber valueX4     ; Value in ax        
            mov bx, 04h
            mul bx                      ; AX = valueX4 * 4
            ConvertToString valueXD3
            ConcatText string, valueXD3, SIZEOF valueXD3
            mov string[si], 58h         ; X
            inc si
            mov string[si], 33h         ; 3
            inc si

        ; X3 -> X2
        X2:
            ConvertToNumber valueX3     ; Value in ax        
            mov bx, 03h
            mul bx                      ; AX = valueX3 * 3
            ConvertToString valueXD2
            mov string[si], 2bh         ; +
            inc si
            ConcatText string, valueXD2, SIZEOF valueXD2
            mov string[si], 58h         ; X
            inc si
            mov string[si], 32h         ; 2
            inc si

        ; X2 -> X1
        X1:
            ConvertToNumber valueX2     ; Value in ax        
            mov bx, 02h
            mul bx                      ; AX = valueX3 * 2
            ConvertToString valueXD1
            mov string[si], 2bh         ; +
            inc si
            ConcatText string, valueXD1, SIZEOF valueXD1
            mov string[si], 58h         ; X
            inc si
            mov string[si], 31h         ; 1
            inc si        
        
        ; X1 -> X0
        X0:
            ConvertToNumber valueX1     ; Value in ax        
            ConvertToString valueXD0
            mov string[si], 2bh         ; +
            inc si
            ConcatText string, valueXD0, SIZEOF valueXD0

        Popear
    endm





;*******************************************************************************
;					FUNCIONES UTILIZADAS PARA REALIZAR INTEGRALES 
;*******************************************************************************

    getIFunction macro string
        local X5, NegativeX5, FollowX5, EndNegX5, EndPosX5, X4, NegativeX4, FollowX4, EndNegX4, EndPosX4, X3, NegativeX3, FollowX3, EndNegX3, EndPosX3, X2, NegativeX2, FollowX2, EndNegX2, EndPosX2, X1, NegativeX1, FollowX1, EndNegX5, EndPosX5, X0, NegativeX0, FollowX0
        Pushear
        xor si, si
        ConcatText string, msgIntegral, SIZEOF msgIntegral

        ; X4 -> X5
        X5:
            ConvertToNumber valueX4
            xor di, di
            test ax, 1000000000000000b
                jnz NegativeX5
            jmp FollowX5

            NegativeX5:
                neg ax
            
			FollowX5:
            mov bl, 05h
            div bl

            ConvertToString valueXI5
            ConcatText string, valueX4, SIZEOF valueX4

            mov string[si], 2fh             ; /
            inc si
            mov string[si], 35h             ; 5
            inc si
            mov string[si], 58h             ; X
            inc si
            mov string[si], 35h             ; 5
            inc si

        ; X3 -> X4
        X4:
            mov string[si], 2bh         ; +
            inc si
            ConvertToNumber valueX3
            test ax, 1000000000000000b
                jnz NegativeX4
            jmp FollowX4
            
			NegativeX4:
                neg ax
            
			FollowX4:
            mov bl, 04h
            div bl
            xor ah, ah

            ConvertToString valueXI4
            ConcatText string, valueX3, SIZEOF valueX3

            mov string[si], 2fh             ; /
            inc si
            mov string[si], 34h             ; 4
            inc si
            mov string[si], 58h             ; X
            inc si
            mov string[si], 34h             ; 4
            inc si

        ; X2 -> X3
        X3:
            mov string[si], 2bh         ; +
            inc si
            ConvertToNumber valueX2
            test ax, 1000000000000000b
                jnz NegativeX3
            jmp FollowX3
            
            NegativeX3:
                neg ax
           
		    FollowX3:
            mov bl, 03h
            div bl
            xor ah, ah

            ConvertToString valueXI3
            ConcatText string, valueX2, SIZEOF valueX2

            mov string[si], 2fh             ; /
            inc si
            mov string[si], 33h             ; 3
            inc si
            mov string[si], 58h             ; X
            inc si
            mov string[si], 33h             ; 3
            inc si

        ; X1 -> X2
        X2:
            mov string[si], 2bh         ; +
            inc si
            ConvertToNumber valueX1
            test ax, 1000000000000000b
                jnz NegativeX2
            jmp FollowX2
            
            NegativeX2:
                neg ax
            FollowX2:
            mov bl, 02h
            div bl
            xor ah, ah

            ConvertToString valueXI2
            ConcatText string, valueX1, SIZEOF valueX1

            mov string[si], 2fh             ; /
            inc si
            mov string[si], 32h             ; 2
            inc si
            mov string[si], 58h             ; X
            inc si
            mov string[si], 32h             ; 2
            inc si


        ; X0 -> X1
        X1:
            mov string[si], 2bh         ; +
            inc si

            ConvertToNumber valueX0
            ConvertToString valueXI1
            ConcatText string, valueX0, SIZEOF valueX0

            mov string[si], 58h             ; X
            inc si
            mov string[si], 31h             ; 1
            inc si


        ; +C
        X0:
            ConcatText string, msgC, SIZEOF msgC

        Popear
    endm


