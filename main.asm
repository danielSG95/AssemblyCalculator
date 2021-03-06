include smachine.asm
include macros.asm
include operar.asm 
include grafica.asm


.model small

; STACK SEGMENT
.stack

; DATA SEGMENT
.data

    ;   PRUEBA 
        testing db 'testing :', '$'
        saliendomsg db 'Saliendo', '$'
        msgError db 'Error en el automata >:v/', '$'
        estado0 db 'S0 ', '$'
        estado1 db 'S1 ', '$'
        estado2 db 'S2 ', '$'
        estado3 db 'S3 ', '$'
        estado4 db 'S4 ', '$'
        estado5 db 'S5 ', '$'
        estado6 db 'S6 ', '$'

        msgIt db 'Iterando ', '$'

        msg1 db 'Analizando', 13, 10, '$'
        msg2 db 'Antes de ', 13, 10 ,'$'


        newLine db 13, 10, '$'
        cleanChar db '             ', '$'
        tab db 9, '$'

    ; CABECERAS Y MENUS
        ; MENU PRINCIPAL
            menu db 13, 10, 9, '### MENU ###', 13, 10, 9, '1) Ingresar Funcion f(x)', 
            13, 10, 9, '2) Funcion en memoria', 13, 10, 9, '3) Derivada f`(x)', 
            13, 10, 9, '4) Integral F(x)', 13, 10, 9, 
            '5) Graficar Funciones', 13, 10, 9, '8) Salir', 13, 10, '$'
            
            encabezado db 'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA', 10,13,
            'ARQUITECTURA DE ENSAMBLADORES Y COMPUTADORES 1', 13, 10,
            'Daniel Enrique Santos Godoy - 201325512', 13,10,
            'Carlos Arnoldo Lopez Coroy - 201313894', 13,10, '$'

            msgRoute db 'Ingrese la ruta (##ruta.arq##): ', '$'

        ; INGRESAR FUNCION
            subMenuF1 db 13, 10, 9, '1- Ingresar Funcion', '$'
            subMenuF2 db 13, 10, 9,'2- Cargar Archivo', '$'
            subMenuF3 db 13, 10, 9,'3- Regresar', 10, 9, '$'
            subMenuF4 db 13, 10, 9, 'Ingrese la ruta del archivo:', '$'
            headerEnterF db 'INGRESE LOS COEFICIENTES DE LA FUNCION: ', 13, 10, '$'
            msgEnterF db '- Coeficiente de x', '$'
            msgX4 db '4: ', '$'
            msgX3 db '3: ', '$'
            msgX2 db '2: ', '$'
            msgX1 db '1: ', '$'
            msgX0 db '0: ', '$'

        ; FUNCTION EN MEMORIA
            headerFunctionM db 'Funcion en memoria f(x): ', 13, 10, '$'
            msgFunctionM db 'f(x) = '
            txtFunction db 500 dup('$')

        ; DERIVADA 
            headerDerived db 'DERIVADA DE f(x): ', 13, 10, '$'
            msgDerived db 'f`(x) = ', '$'
        
        ; INTEGRAL
            headerIntegral db 'INTEGRAL DE f(x): ', 13, 10, '$'
            msgIntegral db 'F(x) = ', '$'
            msgC db ' + c', '$'
            msgEnterC db 'Ingrese el valor c: ', '$'
        
        ; GRAFICA
            menuGraph db 9, 9, '-_-MENU GRAFICAR-_-', 13, 10, '1) Graficar Original f(x)', 13, 10, '2) Graficar Derivada f`(x)', 13, 10, '3) Graficar Integral F(x)', 13, 10, '4) Regresar f(x)', 13, 10, '$'
            msgEnterInterval db 'Ingrese el valor ', '$'
            msgEIU db 'final ', '$'
            msgEID db 'inicial ', '$'
            msgEnterIntervalF db 'del intervalo: ', '$'

    ; "VARIABLES"

        ; archivos
        handler dw ?
        bufferRead db 1000 dup('$'), '$'
        auxiliarReader db 150 dup(0), '$' ; lo utilizare para obtener la ruta del archivo

        varAux db 10 dup('$'), '$'

        selectionGraph db 31h
        functionToShow db 500 dup('$'), '$' ; que tan grande lo puedo hacer ?? 
        functionsDInMemory db 1000 dup('$'), '$' ; para guardar las funciones derivadas
        functionsInMemory db 1000 dup('$'), '$' ; para guardar las funciones integradas
        
        valueX4 db 10 dup('$'), '$'
        valueX3 db 10 dup('$')
        valueX2 db 10 dup('$')
        valueX1 db 10 dup('$')
        valueX0 db 10 dup('$')

        valueXD3 db 10 dup('$')
        valueXD2 db 10 dup('$')
        valueXD1 db 10 dup('$')
        valueXD0 db 10 dup('$')

        valueXI5 db 10 dup('$')
        valueXI4 db 10 dup('$')
        valueXI3 db 10 dup('$')
        valueXI2 db 10 dup('$')
        valueXI1 db 10 dup('$')
        valueXI0 db 10 dup('$')

        inferiorLimit db 10 dup('$')
        superiorLimit db 10 dup('$')

    ; ERRORES
        msgErrorNoFunction db 'No ingreso funcion alguna', '$'
        msgErrorRoute db 'No ingreso el formato de ruta esperado', '$'
        msgErrorWrite db 'Error al escribir en el archivo', '$'
        msgErrorOpen db 'Error al abrir el archivo. Puede que no exista o la extension este mala', '$'
        msgErrorCreate db 'Error al crear el archivo', '$'
        msgErrorClose db 'Error al cerrar el archivo', '$'
        msgErrorRead db 'Error al leer el archivo', '$'

.code

main proc

    mov ax, @data
    mov ds, ax

    Start:
        ; clr
        print encabezado
        print newLine
        ; MENU
        print menu
        getChar

        clr
            cmp al, 31h ;1
                je subMenuFuncion
            cmp al, 32h ;2
                je EnterFunctionMemory
            cmp al, 33h ;3
                je Derived
            cmp al, 34h ;4
                je Integral
            cmp al, 35h ;5
                je Graph
            cmp al, 38h ;8
                je Exit
        jmp Start

    subMenuFuncion:
        print subMenuF1
        print subMenuF2
        print subMenuF3
        getChar
        cmp al, 31h ; ingresar 
            je EnterFunction
        cmp al, 32h ;  Cargar archivo
            je loadFunctions
        cmp al, 33h ; regresar. 
            je Start
        jmp Start
    EnterFunction:
        print headerEnterF
        
        ; X4
            print msgEnterF
            print msgX4

            getText valueX4
            
        ; X3
            print msgEnterF
            print msgX3
            
            getText valueX3

        ; X2
            print msgEnterF
            print msgX2
            
            getText valueX2

        ; X1
            print msgEnterF
            print msgX1

            getText valueX1

        ; X0
            print msgEnterF
            print msgX0

            getText valueX0

        jmp Start
    EnterFunctionMemory:
        xor si, si
        cmp valueX4[si], 24h
            jne ShowFunction
        cmp valueX3[si], 24h
            jne ShowFunction
        cmp valueX2[si], 24h
            jne ShowFunction
        cmp valueX1[si], 24h
            jne ShowFunction
        cmp valueX2[si], 24h
            jne ShowFunction

        print msgErrorNoFunction
        getChar
        jmp Start

                ; esto hay que revisarla
        ShowFunction:
            print headerFunctionM

            Clean functionToShow, SIZEOF functionToShow, 24h

            GetOFunction functionToShow

            print tab

            print functionToShow

            getChar

        jmp Start
    loadFunctions:
        ; aqui leo el archivo y lo cargo al bufferRead
        ; tambien se deberia de analizar
        print subMenuF4
        getText auxiliarReader
        _openFile auxiliarReader, handler
        _readFile handler, bufferRead, SIZEOF bufferRead
        
        print msg1
        getChar
        ; testing area 
        
        
        AnalyzeFile
        jmp Start
    Derived:
        xor si, si
        ; se verifica que no este vacio.
        cmp valueX4[si], 24h ;$
            jne ShowDFunction
        cmp valueX3[si], 24h
            jne ShowDFunction
        cmp valueX2[si], 24h
            jne ShowDFunction
        cmp valueX1[si], 24h
            jne ShowDFunction
        cmp valueX2[si], 24h
            jne ShowDFunction

        print msgErrorNoFunction
        getChar
        jmp Start

        ShowDFunction:
            print headerDerived

            Clean functionToShow, SIZEOF functionToShow, 24h  ; limpia la variable de entrada de ecuacion

            getDFunction functionToShow

            print tab

            print functionToShow

            getChar

        jmp Start


    Integral:
        xor si, si
        cmp valueX4[si], 24h
            jne ShowIFunction
        cmp valueX3[si], 24h
            jne ShowIFunction
        cmp valueX2[si], 24h
            jne ShowIFunction
        cmp valueX1[si], 24h
            jne ShowIFunction
        cmp valueX2[si], 24h
            jne ShowIFunction

        print msgErrorNoFunction
        getChar
        jmp Start

        ShowIFunction:
            print headerIntegral

            Clean functionToShow, SIZEOF functionToShow, 24h

            getIFunction functionToShow

            print tab

            print functionToShow

            getChar

        jmp Start
    Graph:

        print menuGraph
        pushStack
        getChar
        cmp al, 34h
            je Start

        Push ax

        print newLine
        print msgEnterInterval
        print msgEID
        print msgEnterIntervalF
        getText inferiorLimit
        print newLine
        print msgEnterInterval
        print msgEIU
        print msgEnterIntervalF
        getText superiorLimit

        Pop ax

        cmp al, 31h
            je GraphOriginal
        cmp al, 32h
            je GraphDerived
        cmp al, 33h
            je GraphIntegral

        GraphOriginal:
            ; VIDEO MODE
            mov ax, 0013h
            int 10h

            GraphAxis
            GraphOriginalMacro inferiorLimit, superiorLimit
            ; print bufferSerie
            jmp EndGraph

        GraphDerived:            
            ; VIDEO MODE
            mov ax, 0013h
            int 10h
            
            getDFunction functionToShow
            
            GraphAxis
            
            GraphDerivedMacro inferiorLimit, superiorLimit
            jmp EndGraph            
        GraphIntegral:
            print newLine
            print msgEnterC

            getText valueXI0

            ; VIDEO MODE
            mov ax, 0013h
            int 10h

            getIFunction functionToShow

            GraphAxis

            GraphIntegralMacro inferiorLimit, superiorLimit
        EndGraph:
            ; WAIT
            mov ah, 10h
            int 16h

            ; TEXT MODE
            mov ax, 0003h
            int 10h

            ; llamar aqui a enviar serie.
            popStack

            jmp Start
    
    Exit:
        mov ah, 4ch     ; END PROGRAM
        xor al, al
        int 21h
    ; ERRORS
        errorClosingFile:
            print msgErrorClose
            getChar
            clr
            jmp Start
        errorOpeningFile:
            print msgErrorOpen
            getChar
            clr
            jmp Start
        errorReadingFile:
            print msgErrorRead
            getChar
            clr
            jmp Start
        
main endp

end
