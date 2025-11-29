mydata  SEGMENT PARA 'd'
dizi    DB 1, 2, 3, 4, 5
n       DW 5
S       DB 0
mydata  ENDS
mystack SEGMENT PARA STACK 'SSSS'
        DW 12 DUP(?)
mystack ENDS
mycode  SEGMENT PARA 'kokkk'
        ASSUME CS:mycode, SS:mystack, DS:mydata
ANA     PROC FAR
        PUSH DS
        XOR AX, AX
        PUSH AX
        MOV AX, mydata
        MOV DS, AX

        MOV BX, 0
        MOV CX, n
        XOR SI, SI
        DEC CX
dOn:    CMP BX, 0
        JNE LSon
        CMP SI, CX
        JAE L5
        MOV AL, dizi[SI]
        CMP AL, dizi[SI+1]
        JLE L3
        MOV BX, 1
L3:     inc SI
        JMP DoN
L5:     MOV S, 1
LSon:   RETF
ANA     ENDP
mycode  ENDS
        END ANA