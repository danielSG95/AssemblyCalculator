; PRINT ON THE SCREEN
print macro string
    Pushear
    mov ah, 09h             ; PRINT
    mov dx, offset string
    int 21h
    Popear
endm

; GET CHARACTER
getChar macro    
    mov ah, 01h
    int 21h
endm

; CLEAN STRING
Clean macro string, numBytes, char
    local RepeatLoop
    Pushear
    xor si, si
    xor cx, cx
    mov cx, numBytes
    RepeatLoop:
        mov string[si], char
        inc si
    Loop RepeatLoop
    Popear
endm

; GET TEXT UNTIL THE USER WRITE ENTER
getText macro string
    local getCharacter, EndGC, Backspace
    xor si, si
    xor ax, ax
    getCharacter:
        getChar
        cmp al, 0dh
            je EndGC
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
    EndGC:        
        mov al, 24h
        mov string[si], al
endm

; Move cursor
; The screen in text mode have 25 rows and 80 columns
moveCursor macro row, column
    Pushear
    mov ah, 02h
    mov dh, row
    mov dl, column
    int 10h
    Popear
endm

; CLEAN CONSOLE
ClearConsole macro
    local ClearConsoleRepeat
    Pushear
    mov dx, 50h
    ClearConsoleRepeat:
        print newLine
    Loop ClearConsoleRepeat
    moveCursor 00h, 00h
    Popear
endm

printPixel macro x, y, color
    Pushear

    mov ah, 0ch
    mov al, color
    mov bh, 0h
    mov dx, y
    mov cx, x

    int 10h

    Popear
endm

ConcatText macro string1, string2, numBytes
    local RepeatConcat, EndGC

    xor di, di
    mov cx, numBytes
    RepeatConcat:
        mov al, string2[di]
        cmp al, 24h
            je EndGC
        inc di
        mov string1[si], al
        inc si
    Loop RepeatConcat
    EndGC:
endm
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\     FILES     \\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    ; GET ROUTE OF A FILE
    getRoute macro string
        local getCharacter, EndGC, Backspace
        Pushear
        xor si, si
        getCharacter:
            getChar
            ; If al == \n
            cmp al, 0dh
                je EndGC
            ; If al == \b
            cmp al, 08h
                je Backspace
            ; else
            mov string[si], al
            inc si
            jmp getCharacter
        Backspace:
            mov al, 24h
            dec si
            mov string[si], al
            jmp getCharacter
        EndGC:        
            mov al, 00h
            mov string[si], al
            Popear
    endm

    ; OPEN FILE
    OpenFile macro route, handler
        Pushear
        mov ah, 3dh
        mov al, 020h
        lea dx, route
        int 21h
        mov handler, ax
        ; JUMP IF AN ERROR OCCURRED WHILE OPENING THE FILE
        jc OpenError    
        Popear
    endm

    ; CLOSE FILE
    CloseFile macro handler
        mov ah, 3eh
        mov bx, handler
        int 21h
        ; JUMP IF THE FILE DOESNT CLOSE FINE
        jc CloseError
    endm

    ; CREATE FILE
    CreateFile macro string, handler
        mov ah, 3ch
        mov cx, 00h
        lea dx, string
        int 21h
        mov handler, ax
        ; JUMP IF AN ERROR OCCURS WHILE CREATING THE FILE
        jc CreateError    
    endm

    ; WRITE ON FILE
    WriteOnFile macro handler, info, numBytes
        PUSH ax
        PUSH bx
        PUSH cx
        PUSh dx
        
        mov ah, 40h
        mov bx, handler
        mov cx, numBytes
        lea dx, info
        int 21h
        ; JUMP IF AN ERROR OCCURS DURING WRITING IN THE FILE
        jc WriteError

        POP dx
        POP cx
        POP bx
        POP ax
    endm

    ; READ FILE
    ReadFile macro handler, info, numBytes    
        mov ah, 3fh
        mov bx, handler
        mov cx, numBytes
        lea dx, info
        int 21h    
        jc ReadError
    endm

    GenerateReport macro string
        xor si, si

        ConcatText string, headerReport, SIZEOF headerReport

        ConcatText string, Fdate, SIZEOF Fdate

        ConcatText string, dateMsg, SIZEOF dateMsg

        ConcatText string, newLine, SIZEOF newLine

        ConcatText string, originalMsg, SIZEOF originalMsg

        Clean functionToShow, SIZEOF functionToShow, 24h

        GetOFunction functionToShow

        ConcatText string, tab, SIZEOF tab

        ConcatText string, functionToShow, SIZEOF functionToShow

        ConcatText string, newLine, SIZEOF newLine

        ConcatText string, derivedMsg, SIZEOF derivedMsg
        
        Clean functionToShow, SIZEOF functionToShow, 24h

        getDFunction functionToShow

        ConcatText string, tab, SIZEOF tab

        ConcatText string, functionToShow, SIZEOF functionToShow

        ConcatText string, newLine, SIZEOF newLine

        ConcatText string, integralMsg, SIZEOF integralMsg

        Clean functionToShow, SIZEOF functionToShow, 24h

        getIFunction functionToShow

        ConcatText string, tab, SIZEOF tab

        ConcatText string, functionToShow, SIZEOF functionToShow
    endm

    CheckRoute macro route
        local First, Begin, EndGC
        
        xor si, si

        mov si, SIZEOF route

        Begin:
            dec si
            cmp route[si], 00h
                je Begin
            cmp route[si], '#'
                je EndGC
        jmp InvalidRouteError
        EndGC:
            mov route[si], 00h
            dec si
            cmp route[si], '#'
                jne InvalidRouteError
            mov route[si], 00h
            dec si
            cmp route[si], 'q'
                jne InvalidRouteError
            dec si
            cmp route[si], 'r'
                jne InvalidRouteError
            dec si
            cmp route[si], 'a'
                jne InvalidRouteError
            dec si
            cmp route[si], '.'
                jne InvalidRouteError
    endm

    MoveRoute macro string
        local RepeatMove
        xor si, si
        mov cx, SIZEOF string
        RepeatMove:
            mov al, string[si+2]            
            mov string[si], al
            inc si
        Loop RepeatMove
    endm

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\ GET DATE \\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    ; PRINCIPAL MACRO FOR DATE AND HOUR
    getDateAndHour macro stringDate
        
        Pushear
        xor si, si

        getDate
        ; DL = DAY. DH = MONTH

        ConvertToStringDH stringDate, dl ; NUMBER -> STRING. DAY

        mov stringDate[si], 2fh ; /
        inc si

        ConvertToStringDH stringDate, dh ; NUMBER -> STRING. MONTH

        mov stringDate[si], 2fh ; /
        inc si

        mov stringDate[si], 32h ; 2
        inc si

        mov stringDate[si], 30h ; 0
        inc si

        mov stringDate[si], 32h ; 2
        inc si

        mov stringDate[si], 30h ; 0
        inc si

        mov stringDate[si],20h
        inc si
        mov stringDate[si],20h
        inc si

        getHour
        ; CH = HOUR. CL = MINUTES.
        
        ConvertToStringDH stringDate, ch ; NUMBER -> STRING. HOUR

        mov stringDate[si],3ah ; :
        inc si

        ConvertToStringDH stringDate, cl ; NUMBER -> STRING. MINUTES

        mov stringDate[si],3ah ; :
        inc si

        ConvertToStringDH stringDate, dh ; NUMBER -> STRING. SECONDS

        Popear
    endm

    ; GET DATE
    getDate macro 
        mov ah, 2ah
        int 21h
    endm

    ; GET HOUR
    getHour macro
        mov ah, 2ch
        int 21h
    endm

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\ CONVERSIONS \\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    ConvertToNumber macro string
        local Begin, EndGC, PositiveSymbol, NegativeSymbol, Negative
        Push si
        
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        mov bx, 10
        xor si, si
        xor di, di
        ; Check signs
        Begin:
            mov cl, string[si]      
            ; If the ascii is +
            cmp cl, '+'
                je PositiveSymbol
            ; If the ascii is -
            cmp cl, '-'
                je NegativeSymbol
            ; If the ascii is less than the ascii of 0
            cmp cl, 48
                jl EndGC
            ; If the ascii is more than the ascii of 9
            cmp cl, 57
                jg EndGC
            inc si
            sub cl, 48  ; Subtract 48 to get the number
            mul bx      ; Multiply by 10
            add ax, cx

            jmp Begin
        PositiveSymbol:
            inc si
            jmp Begin
        NegativeSymbol:
            inc di            
            inc si
            jmp Begin
        Negative:
            xor di, di
            neg ax
            xor dx, dx
        EndGC:        
            cmp di, 01h
                je Negative
            Pop si
    endm

    ConvertToString macro string
        local Divide, Divide2, EndCr3, Negative, End2, EndGC
        Push si
        xor si, si
        xor cx, cx
        xor bx, bx
        xor dx, dx
        mov dl, 0ah
        test ax, 1000000000000000b
            jnz Negative
        jmp Divide2
        Negative:
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
            cmp al, 00h
                je EndCr3
            jmp Divide
        EndCr3:
            pop ax
            add ah, 30h
            mov string[si], ah
            inc si
        Loop EndCr3
        mov ah, 24h
        mov string[si], ah
        inc si
        EndGC:
            Pop si
    endm

    ConvertToStringDH macro string, numberToConvert
        Push ax
        Push bx

        xor ax, ax
        xor bx, bx
        mov bl, 0ah
        mov al, numberToConvert
        div bl

        getNumber string, al
        getNumber string, ah

        Pop ax
        Pop bx
    endm


    getNumber macro string, numberToConvert
        local zero, one, two, three, four, five, six, seven, eight, nine
        local EndGC

        cmp numberToConvert, 00h
            je zero
        cmp numberToConvert, 01h
            je one
        cmp numberToConvert, 02h
            je two
        cmp numberToConvert, 03h
            je three
        cmp numberToConvert, 04h
            je four
        cmp numberToConvert, 05h
            je five
        cmp numberToConvert, 06h
            je six
        cmp numberToConvert, 07h
            je seven
        cmp numberToConvert, 08h
            je eight
        cmp numberToConvert, 09h
            je nine
        jmp EndGC

        zero:
            mov string[si], 30h
            inc si
            jmp EndGC
        one:
            mov string[si], 31h
            inc si
            jmp EndGC
        two:
            mov string[si], 32h
            inc si
            jmp EndGC
        three:
            mov string[si], 33h
            inc si
            jmp EndGC
        four:
            mov string[si], 34h
            inc si
            jmp EndGC
        five:
            mov string[si], 35h
            inc si
            jmp EndGC
        six:
            mov string[si], 36h
            inc si
            jmp EndGC
        seven:
            mov string[si], 37h
            inc si
            jmp EndGC
        eight:
            mov string[si], 38h
            inc si
            jmp EndGC
        nine:
            mov string[si], 39h
            inc si
            jmp EndGC
        EndGC:
    endm

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\ RECOVER THINGS \\\\\\\\\\\\\\\\\\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    Pushear macro
        push ax
        push bx
        push cx
        push dx
        push si
        push di
    endm

    Popear macro                    
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
    endm