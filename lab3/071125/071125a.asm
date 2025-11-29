        INCLUDE 071125.mac
myss    SEGMENT PARA STACK 'yigin'
        DW 20 DUP(?)
myss    ENDS
myds    SEGMENT PARA 'veri'
n       DW 8
dizi    DB 10, -2, 7, 4, 10, 11, 6, 5
kucuk   DB ?
myds    ENDS
mycs    SEGMENT PARA 'kod'
        ASSUME CS:mycs, DS:myds, SS:myss
MAIN    PROC FAR
        PUSH DS
        XOR AX, AX
        PUSH AX
        MOV AX, myds
        MOV DS, AX

        XOR SI, SI
        MOV CX, n
L1:     SAR dizi[SI], 1
        INC SI
        LOOP L1
        ENKUCUK dizi, n
        MOV kucuk, AL
                
        RETF
MAIN    ENDP
mycs    ENDS
        END MAIN