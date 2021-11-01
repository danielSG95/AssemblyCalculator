; +ax^4 + bx^4 + cx^2 + dx + e; 
; -ax^4 + bx^4 + cx^2 + dx + e; 
; ax^4 + bx^4 + cx^2 + dx + e; 
AnalyzeFile macro 
LOCAL S0,S1,S2,S3,S4,S5,S6,salir,fin
Pushear
xor si, si
xor di, di
xor ax, ax
xor bx, bx
xor dx, dx
S0: ;estado inicial
    mov al, bufferRead[si]
    cmp al, 2bh ; + 
    je S1
    
    cmp al, 2dh ; - 
    je S1

    push bl
    isDigit al
    cmp bl, 1
    pop bl
    je S2

    ; entonces es un error. 
    jmp fin
S1:
    inc si ;necesito aumentar el contador antes de seguir analizando. 
    mov dx, al
S2:
S3:
S4:
S5:
S6:
fin:
    ;ejecutar sub-rutina una ultima vez.
salir:    
    Popear
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