            PUBLIC SIRALI_MI
            EXTRN dizi:BYTE, n:WORD
mycode      SEGMENT PARA 'kkk'
            ASSUME CS:mycode
SIRALI_MI   PROC FAR
            PUSH BX
            PUSH CX

            XOR AX, AX
            XOR BX, BX
            MOV CX, n
            DEC CX
L1:         CMP BX, CX
            JAE sirali
            MOV AH, dizi[BX]
            CMP AH, dizi[BX+1]
            JG sirasiz
            INC BX
            JMP L1 
sirasiz:    MOV AL, 1

sirali:     POP CX
            POP BX
            RETF
SIRALI_MI   ENDP
mycode      ENDS
            END