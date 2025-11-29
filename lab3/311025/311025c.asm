            PUBLIC USTAL
mycode      SEGMENT PARA 'kkkk'
            ASSUME CS:mycode
USTAL       PROC FAR
            PUSH DX
            MOV AX, 1
L1:         MUL BX              ; DX:AX <- AX * BX
            LOOP L1
            POP DX
            RET
USTAL       ENDP
mycode      ENDS
            END