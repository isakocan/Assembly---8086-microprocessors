            PUBLIC FACTORIZE
            EXTRN FACTORS:WORD, FACT_COUNT:WORD, NUMBER_LIST:WORD
mycode      SEGMENT PARA 'CODE'
            ASSUME CS:mycode
FACTORIZE   PROC FAR
            
            PUSH CX

            XOR DI, DI
            MOV FACT_COUNT, 0

            MOV AX, NUMBER_LIST[SI]
            MOV BX, 2

TWOS_LOOP:  XOR DX, DX
            DIV BX
            CMP DX, 0
            JNZ DONE_FOR_TWO
            MOV FACTORS[DI], 2
            ADD DI, 2
            INC FACT_COUNT
            JMP TWOS_LOOP
            
DONE_FOR_TWO:
            INC BX
            MOV CX, AX

FACTOR_LOOP:
            MOV AX, BX
            MUL AX

            CMP DX, 0
            JNE END_OF_LOOP

            CMP AX, CX
            JA END_OF_LOOP
            
            XOR DX, DX
            MOV AX, CX

INNER_LOOP: DIV BX
            CMP DX, 0
            JNZ NOT_FACTOR

            MOV FACTORS[DI], BX
            ADD DI, 2
            INC FACT_COUNT
            MOV CX, AX
            JMP INNER_LOOP
            
NOT_FACTOR:        
            ADD BX, 2
            JMP FACTOR_LOOP

END_OF_LOOP:

            CMP CX, 1
            JE FINISH
            MOV FACTORS[DI], CX
            INC FACT_COUNT

FINISH:     POP CX
            RETF
FACTORIZE   ENDP
mycode      ENDS
            END