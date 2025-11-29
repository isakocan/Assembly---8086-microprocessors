            EXTRN USTAL:FAR
my_ss       SEGMENT PARA STACK 'stack'
            DW 20 DUP(?)
my_ss       ENDS
my_ds       SEGMENT PAGE 'data'
sayi        DW 2
ust         DW 10
sonuc       DW ?
my_ds       ENDS
my_cs       SEGMENT WORD 'code'
            ASSUME CS:my_cs, DS:my_ds, SS:my_ss
ANA         PROC FAR
            PUSH DS
            XOR AX, AX
            PUSH AX
            MOV AX, my_ds
            MOV DS, AX
            MOV CX, ust
            MOV BX, sayi
            CALL USTAL
            MOV sonuc, AX
            RETF
ANA         ENDP
my_cs       ENDS
            END ANA