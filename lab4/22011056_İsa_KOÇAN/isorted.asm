            PUBLIC IS_SORTED
            ; stack sp: is_sorted_flag -> dizi -> n
mycs SEGMENT PARA 'CODE'
            ASSUME CS: mycs
IS_SORTED   PROC FAR
            PUSH BP
            MOV BP, SP
            PUSH SI
            PUSH CX
            PUSH BX
            PUSH DX
   
            MOV SI, [BP+8] ; dizi
            MOV CX, [BP+6] ; N
            DEC CX         ; N-1

            MOV AX, 1      ;Flag=1. Dizi sırasız ise sıfırlayacağız. 

            CMP CX, 0
            JBE FINISH

CHECK_IS_SORTED: 
            CMP CX, 0
            JE FINISH

            MOV BX, [SI]    ;dizi[i]
            MOV DX, [SI+2]  ;dizi[i+1]
            CMP BX, DX
            JA NOT_SORTED

            ADD SI, 2
            DEC CX
            JMP CHECK_IS_SORTED
     
NOT_SORTED: XOR AX, AX

FINISH:     MOV [BP+10], AX     ;RETURN
            
            POP DX
            POP BX
            POP CX
            POP SI
            POP BP

            RETF 4      ; POP n -> dizi ->
IS_SORTED   ENDP
mycs        ENDS
            END