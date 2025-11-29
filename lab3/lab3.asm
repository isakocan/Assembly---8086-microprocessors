            EXTRN IS_PRIME:FAR, FACTORIZE:FAR, MAX_FACTOR:FAR
            PUBLIC FACTORS, FACT_COUNT, NUMBER_LIST, MAX_FACTOR_RESULT
my_ss       SEGMENT PARA STACK 'stack'
            DW 20 DUP(?)
my_ss       ENDS

my_ds       SEGMENT PAGE 'data'
NUMBER_LIST DW 2, 162, 13, 997, 91, 60060, 25965, 1, 0
NUMBER_COUNT DW 9
FACTORS DW 16 DUP(?)
FACT_COUNT DW ?
IS_PRIME_FLAG DW 0
MAX_FACTOR_RESULT  DW ?
my_ds       ENDS

my_cs       SEGMENT WORD 'code'
            ASSUME CS:my_cs, DS:my_ds, SS:my_ss
main        PROC FAR

            PUSH DS
            XOR AX, AX
            PUSH AX
            MOV AX, my_ds
            MOV DS, AX

            MOV CX, NUMBER_COUNT
            XOR SI, SI

L1:         MOV BX, NUMBER_LIST[SI]
            CALL IS_PRIME
            MOV IS_PRIME_FLAG, AX
            CMP AX, 0
            JNE PRIME

            CALL FACTORIZE

            MOV  DI, FACT_COUNT
            CALL MAX_FACTOR
            ;PRİNT 'ASAL DEĞİL' FACTORS[], MAX_FACTOR
            JMP J1

PRIME:      MOV AX, NUMBER_LIST[SI]
            MOV MAX_FACTOR_RESULT, AX 
            ;PRINT MAX_FACTOR_RESULT00

J1:         ADD SI, 2
            LOOP L1
            
            RETF
main        ENDP
my_cs       ENDS
            END main