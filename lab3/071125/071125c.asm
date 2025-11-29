            PUBLIC ALAN_BUL
mycode      SEGMENT PARA 'kkk'
            ASSUME CS:mycode
ALAN_BUL    PROC FAR
            PUSH BX
            PUSH CX
            PUSH DI
            PUSH DX
            PUSH BP

            MOV BP, SP
            XOR AX, AX
            ADD AX, [BP+14]
            ADD AX, [BP+16]
            ADD AX, [BP+18]
            SHR AX, 1
            MOV BX, AX
            SUB BX, [BP+14] ;u-c
            MOV CX, AX
            SUB CX, [BP+16] ;u-b
            MOV DI, AX
            SUB DI, [BP+18] ;u-a

            MUL BX  ; u * (u-c)
            MUL CX  ; u * (u-c) * (u-b)
            MUL DI  ; u * (u-c) * (u-b) * (u-a)

            POP BP
            POP DX
            POP DI
            POP CX
            POP BX

            RETF 6
ALAN_BUL    ENDP
mycode      ENDS
            END