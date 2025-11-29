        EXTRN ALAN_BUL:FAR
myss    SEGMENT PARA STACK 'yigin'
        DW 16 DUP(?)
myss    ENDS
myds    SEGMENT PARA 'veri'
kenar   DW 6, 8, 5, 9, 4, 8, 2, 2, 3
n       DW 3
enbyk   DW 0
myds    ENDS
mycs    SEGMENT PARA 'kod'
        ASSUME CS:mycs, DS:myds, SS:myss
MAIN    PROC FAR
        PUSH DS
        XOR AX, AX
        PUSH AX
        MOV AX, myds
        MOV DS, AX

        MOV CX, n
        XOR DI, DI
L1:     PUSH kenar[DI]
        PUSH kenar[DI+2]
        PUSH kenar[DI+4]
        CALL ALAN_BUL
        CMP AX, enbyk
        JB don
        MOV enbyk, AX
don:    ADD DI, 6
        LOOP L1

        RETF
MAIN    ENDP
mycs    ENDS
        END MAIN