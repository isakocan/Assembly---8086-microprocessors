myss    SEGMENT PARA STACK 'yigin'
        DW 20 DUP(?)
myss    ENDS
myds    SEGMENT PARA 'veri'
a       DB 12
b       DB 13
c       DB 12
tip     DB 2
myds    ENDS
mycs    SEGMENT PARA 'kod'
        ASSUME DS:myds, SS:myss, CS:mycs
UCGEN   PROC FAR
        ; Geri donus adreslerini koruyoruz
        PUSH DS
        XOR AX, AX
        PUSH AX
        
        ; Kendi DS'mizi ayarliyoruz
        MOV AX, myds
        MOV DS, AX
        
        MOV AL, a
        MOV BL, b 
        MOV CL, c 
        CMP AL, BL
        JE J1
        CMP AL, CL
        JE JSon
        CMP BL, CL
        JE JSon
        MOV tip, 3
        JMP JSon
J1:     CMP AL, CL
        JNE JSon
        MOV tip, 1
JSon:   RETF
UCGEN   ENDP
mycs    ENDS
        END UCGEN