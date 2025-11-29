        EXTRN SIRALI_MI:FAR
        PUBLIC dizi, n
myss    SEGMENT PARA STACK 'yigin'
        DW 16 DUP(?)
myss    ENDS
myds    SEGMENT PARA 'veri'
dizi    DB 12, 11, 15, 18, 20, 22, 24
n       DW 7
sira    DB 0
myds    ENDS
mycs    SEGMENT PARA 'kod'
        ASSUME CS:mycs, DS:myds, SS:myss
MAIN    PROC FAR
        PUSH DS
        XOR AX, AX
        PUSH AX
        MOV AX, myds
        MOV DS, AX

        CALL SIRALI_MI

        CMP AL, 0
        JZ sirali
        MOV sira, 1
sirali: RETF
MAIN    ENDP
mycs    ENDS
        END MAIN