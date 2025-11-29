            PUBLIC IS_PRIME
mycode      SEGMENT PARA 'CODE'
            ASSUME CS:mycode
IS_PRIME    PROC FAR

            CMP BX, 2
            JB NOT_PRIME            
            JE SET_PRIME

            TEST BX, 1
            JZ NOT_PRIME

            MOV DI, 3
PRIME_LOOP: MOV AX, DI
            MUL AX
            CMP DX, 0
            JNE SET_PRIME
            CMP AX, BX
            JA END_OF_LOOP

            MOV AX, BX
            XOR DX, DX
            DIV DI
            CMP DX, 0
            JZ NOT_PRIME
            ADD DI, 2
            JMP PRIME_LOOP

END_OF_LOOP:    
            JMP SET_PRIME

NOT_PRIME:  XOR AX, AX
            JMP FINISH
SET_PRIME:  MOV AX, 1

FINISH:     RETF
IS_PRIME    ENDP
mycode      ENDS
            END