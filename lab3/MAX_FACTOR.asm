            PUBLIC MAX_FACTOR
            EXTRN FACTORS:WORD, MAX_FACTOR_RESULT:WORD
mycode      SEGMENT PARA 'CODE'
            ASSUME CS:mycode
MAX_FACTOR  PROC FAR
            
            DEC DI
            ADD DI, DI
            MOV DX, FACTORS[DI]
            MOV MAX_FACTOR_RESULT, DX

            RETF
MAX_FACTOR  ENDP
mycode      ENDS
            END