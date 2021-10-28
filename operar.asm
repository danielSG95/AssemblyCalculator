	; todo el codigo referente a las operaciones integrar/ derivar /resolver 
	; excepto algunas macros de uso general, que se queden en macros.asm

include macros.asm

; construye la funcion para mostrarla en pantalla. 
getOFunction macro string
	             local      X4, X3, X2, X1, X0
	             Pushear

	             xor        si, si
        
	             ConcatText string, msgFunctionM, SIZEOF msgFunctionM
                
	X4:          
	             ConcatText string, valueX4, SIZEOF valueX4

	             mov        string[si], 58h                          	; X
	             inc        si
	             mov        string[si], 34h                          	; 4
	             inc        si

	X3:          

	             mov        string[si], 2bh                          	; +
	             inc        si

	             ConcatText string, valueX3, SIZEOF valueX3

	             mov        string[si], 58h                          	; X
	             inc        si
	             mov        string[si], 33h                          	; 3
	             inc        si

	X2:          

	             mov        string[si], 2bh                          	; +
	             inc        si

	             ConcatText string, valueX2, SIZEOF valueX2

	             mov        string[si], 58h                          	; X
	             inc        si
	             mov        string[si], 32h                          	; 2
	             inc        si

	X1:          

	             mov        string[si], 2bh                          	; +
	             inc        si

	             ConcatText string, valueX1, SIZEOF valueX1

	             mov        string[si], 58h                          	; X
	             inc        si
	             mov        string[si], 31h                          	; 1
	             inc        si

	X0:          

	             mov        string[si], 2bh                          	; +
	             inc        si

	             ConcatText string, valueX0, SIZEOF valueX0

	             Popear
    endm


 ; Derivada
getDFunction macro string
	             local           X3, X2, X1, X0
	             Pushear

	             xor             si, si

	             ConcatText      string, msgDerived, SIZEOF msgDerived

	; X4 -> X3
	X3:          
	             ConvertToNumber valueX4                              	; Value in ax

	             mov             bx, 04h

	             mul             bx                                   	; AX = valueX4 * 4

	             ConvertToString valueXD3

	             ConcatText      string, valueXD3, SIZEOF valueXD3

	             mov             string[si], 58h                      	; X
	             inc             si
	             mov             string[si], 33h                      	; 3
	             inc             si

	; X3 -> X2
	X2:          
	             ConvertToNumber valueX3                              	; Value in ax

	             mov             bx, 03h

	             mul             bx                                   	; AX = valueX3 * 3

	             ConvertToString valueXD2

	             mov             string[si], 2bh                      	; +
	             inc             si

	             ConcatText      string, valueXD2, SIZEOF valueXD2

	             mov             string[si], 58h                      	; X
	             inc             si
	             mov             string[si], 32h                      	; 2
	             inc             si

	; X2 -> X1
	X1:          
	             ConvertToNumber valueX2                              	; Value in ax

	             mov             bx, 02h

	             mul             bx                                   	; AX = valueX3 * 2

	             ConvertToString valueXD1

	             mov             string[si], 2bh                      	; +
	             inc             si

	             ConcatText      string, valueXD1, SIZEOF valueXD1

	             mov             string[si], 58h                      	; X
	             inc             si
	             mov             string[si], 31h                      	; 1
	             inc             si
        
	; X1 -> X0
	X0:          
	             ConvertToNumber valueX1                              	; Value in ax

	             ConvertToString valueXD0

	             mov             string[si], 2bh                      	; +
	             inc             si

	             ConcatText      string, valueXD0, SIZEOF valueXD0

	             Popear
    endm

    ; Funcion de integrar
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


;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;;\\\\\\\\\\\\\\\\  CALCULATOR  \\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    AnalizeText macro file
        local StartA, EndGC, EndOperators, InvalidSymbol, CheckEnd, Symbol, Space, SecondAnalize, SymbolPass, SpacePass, InvalidSymbolPass

        xor si, si
        xor ax, ax
        mov si, SIZEOF file

        mov cx, SIZEOF file

        CheckEnd:
            dec si
            mov al, file[si]
            cmp al, ';'
                je StartA
        Loop CheckEnd

        jmp NoEndCharError
        
        StartA:            
            Clean operands, SIZEOF operands, '$'
            Clean operators, SIZEOF operators, '$'
            xor si, si
            xor cx, cx
            ; For the array of operators
            xor di, di

            
        StartAnalize:
            mov al, file[si]

            cmp al, '+'
                je Symbol
            cmp al, '-'
                je Symbol
            cmp al, '*'
                je Symbol
            cmp al, '/'
                je Symbol
            cmp al, ' '
                je Space
            cmp al, ';'
                je EndOperators
            ; If the ascii is less than the ascii of 0
            cmp al, 48
                jl InvalidSymbol
            ; If the ascii is more than the ascii of 9
            cmp al, 57
                jg InvalidSymbol
            ; NUMBER
            inc si
            jmp StartAnalize
        Symbol:
            inc si
            mov operators[di], al
            inc di
            jmp StartAnalize
        Space:
            inc si
            jmp StartAnalize
        InvalidSymbol:
            Push di

            xor di, di
            
            mov cl, al
            mov charI[di], cl
            
            print invalidCharE
            print charI
            getChar
            
            Pop di
            inc si
            jmp StartAnalize

        EndOperators:
            xor si, si
            xor ax, ax
            xor cx, cx
            ; For the array of operands
            xor di, di
            
        SecondAnalize:
            mov al, file[si]

            ; Symbols pass
                cmp al, '+'
                    je SymbolPass
                cmp al, '-'
                    je SymbolPass
                cmp al, '*'
                    je SymbolPass
                cmp al, '/'
                    je SymbolPass
                cmp al, ' '
                    je SpacePass
                cmp al, ';'
                    je EndGC
                ; If the ascii is less than the ascii of 0
                cmp al, 48
                    jl InvalidSymbolPass
                ; If the ascii is more than the ascii of 9
                cmp al, 57
                    jg InvalidSymbolPass
            ; NUMBER            
                inc si
                ; Al -> x10. Ah -> x1.
                mov ah, file[si]

                Push di

                xor di, di

                Clean auxInt, SIZEOF auxInt, '$'

                mov auxInt[di], al
                inc di
                mov auxInt[di], ah

                Pop di

                ConvertToNumber auxInt                

                mov operands[di], ax

                inc di
                inc di
                inc si
                
            jmp SecondAnalize
        SymbolPass:
            inc si            
            jmp SecondAnalize
        SpacePass:
            inc si
            jmp SecondAnalize
        InvalidSymbolPass:        
            inc si
            jmp SecondAnalize

        EndGC:
            cmp charI[00h], 00h
                jne Start
            mov operands[di], 4fh    ; O
            inc di
            inc di
            mov operands[di], 54h   ; T
            inc di
            inc di
            mov operands[di], 54h   ; T
            inc di
            inc di
            mov operands[di], 4fh    ; O
            OperateMacro
    endm

    OperateMacro macro
        local EndGC, Division, Multiplication, Subtraction, Addition
        ; operators --- operands

        xor si, si
        xor di, di
        
        mov cx, SIZEOF operators
        Division:
            mov al, operators[si]
            cmp al, '/'
                je MakeDivision
            cmp al, '$'
                je EndDiv
            jmp NextDiv

            MakeDivision:
                xor dx, dx     
                mov ax, operands[di]

                inc di
                inc di
                mov bx, operands[di]

                div bx                  ; Operands[di] / Operands[di+1]                
                
                Clean auxInt, SIZEOF auxInt, '$'

                ConvertToString auxInt

                ConvertToNumber auxInt

                dec di
                dec di
                mov operands[di], ax

                inc di
                inc di

                ; Move array
                MoveArrays

                ;print operators
                ;print newLine
                ;print operands
                ;getChar

                dec si
                dec di
                dec di

            NextDiv:
                inc di
                inc di
        dec cx
            jne Division 
        
        EndDiv:

        xor si, si
        xor di, di
        
        mov cx, SIZEOF operators
        Multiplication:
            mov al, operators[si]
            cmp al, '*'
                je MakeMultiplication
            cmp al, '$'
                je EndMul
            jmp NextMul

            MakeMultiplication:
                xor dx, dx
                mov ax, operands[di]

                inc di
                inc di
                mov bx, operands[di]

                mul bx

                Clean auxInt, SIZEOF auxInt, '$'

                ConvertToString auxInt

                ConvertToNumber auxInt

                dec di
                dec di
                mov operands[di], ax

                inc di
                inc di

                ; Move array
                MoveArrays

                ;print operators
                ;print newLine
                ;print operands
                ;getChar

                dec di
                dec di
            NextMul:
                inc si
                inc di
                inc di
        dec cx
            jne Multiplication

        EndMul:

        xor si, si
        xor di, di
        
        mov cx, SIZEOF operators
        Subtraction:
            mov al, operators[si]
            cmp al, '-'
                je MakeSub
            cmp al, '$'
                je EndSub
            jmp NextSub

            MakeSub:
                xor dx, dx
                mov ax, operands[di]

                inc di
                inc di
                mov bx, operands[di]

                sub ax, bx

                dec di
                dec di
                mov operands[di], ax

                inc di
                inc di

                ; Move array
                MoveArrays

                ;print operators
                ;print newLine
                ;print operands
                ;getChar

                dec di
                dec di
            NextSub:
                inc si
                inc di
                inc di
        dec cx
            jne Subtraction

        EndSub:

        xor si, si
        xor di, di
        
        mov cx, SIZEOF operators
        Addition:
            mov al, operators[si]
            cmp al, '+'
                je MakeAdd
            cmp al, '$'
                je EndAdd
            jmp NextAdd

            MakeAdd:
                xor dx, dx
                mov ax, operands[di]

                inc di
                inc di
                mov bx, operands[di]

                add ax, bx

                dec di
                dec di
                mov operands[di], ax

                inc di
                inc di

                ; Move Array
                MoveArrays

                ;print operators
                ;print newLine
                ;print operands
                ;getChar

                dec di
                dec di

            NextAdd:
                inc si
                inc di
                inc di
        dec cx
            jne Addition

        EndAdd:
        xor di, di
        mov ax, operands[di]
        Clean auxInt, SIZEOF auxInt, '$'
        ConvertToString auxInt
        print resultMsg
        print auxInt
        getChar
    endm

    MoveArrays macro
        local OperatorsLoop, OperandsLoop, EndOperatorsLoop, EndOperandsLoop, EndGC
        Pushear

        mov cx, SIZEOF operators
        OperatorsLoop:
            mov al, operators[si]
            cmp al, '$'
                je EndOperatorsLoop
            mov al, operators[si+1]
            mov operators[si], al
            inc si

        Loop OperatorsLoop

        EndOperatorsLoop:
            xor cx, cx

        mov cx, SIZEOF operands
        OperandsLoop:
            mov ax, operands[di]
            mov ax, operands[di+2]
            mov operands[di], ax
            inc di
            inc di
        Loop OperandsLoop

        jmp EndGC
        EndGC:
        Popear
    endm