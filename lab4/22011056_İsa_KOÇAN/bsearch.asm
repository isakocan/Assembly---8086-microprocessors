            PUBLIC BINARY_SEARCH
            ; stack sp: result_index -> dizi -> low -> high -> key
mycs SEGMENT PARA 'CODE'
                ASSUME CS: mycs
BINARY_SEARCH   PROC FAR
                
                PUSH BP
                MOV BP, SP
                PUSH BX
                PUSH CX
                PUSH SI
                PUSH DX

                MOV AX, [BP+10] ;LOW
                MOV BX, [BP+8] ;HIGH
                CMP AX, BX      ;LOW > HIGH
                JA NOT_FOUND

                XOR CX, CX
                ADD CX, AX
                ADD CX, BX      
                SHR CX, 1       ;MID

                MOV SI, CX
                SHL SI, 1 
                ADD SI, [BP+12]  ;DİZİ[MİD]
                MOV DX, [BP+6]   ;KEY
                CMP [SI], DX 
                JE  KEY_FOUND
                JB  BS_RIGHT

                ;BS_LEFT
                CMP CX, 0
                JE NOT_FOUND    ;mid=0 ise mid-1->FFFF olacak o yüzden bitirelim

                PUSH [BP+14]    ;RESULT_INDEX
                PUSH [BP+12]    ;Dizi
                PUSH [BP+10]    ;LOW
                DEC CX
                PUSH CX         ;MID-1
                JMP CALL_BS   

BS_RIGHT:       PUSH [BP+14]    ;RESULT_INDEX
                PUSH [BP+12]    ;Dizi
                INC CX
                PUSH CX         ;MID+1
                PUSH [BP+8]     ;HIGH
                

CALL_BS:        PUSH [BP+6]     ;KEY
                CALL BINARY_SEARCH
                POP AX
                MOV [BP+14], AX     ;RETURN 
                JMP EXIT_PROGRAM           

NOT_FOUND:      MOV WORD PTR [BP+14], -1    ; -1 sayısını word olarak al
                JMP EXIT_PROGRAM

KEY_FOUND:      MOV [BP+14], CX

EXIT_PROGRAM:
                POP DX
                POP SI
                POP CX
                POP BX
                POP BP
                RETF 8      ; POP key->high->low->dizi->
BINARY_SEARCH   ENDP
mycs            ENDS
                END