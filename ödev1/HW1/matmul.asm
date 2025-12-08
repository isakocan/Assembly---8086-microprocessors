.386
.model flat, c
.code

PUBLIC matmul_asm


;  B_COLS -> A_COLS -> A_ROWS -> C -> B -> A -> RA -> BP -> i -> j -> k
;BP+28,     +24,       +20,      +16, +12, +8,  +4    0    -4   -8   -12

matmul_asm PROC NEAR
    
    PUSH EBP
    MOV EBP, ESP

    XOR EAX, EAX
    PUSH EAX                ; i = 0
    PUSH EAX                ; j = 0
    PUSH EAX                ; k = 0

    PUSH ESI
    PUSH EBX
    PUSH ECX
    PUSH EDX


    ; i = 0
OUTER_LOOP:
    MOV EAX, [EBP-4]        ; i
    CMP EAX, [EBP+20]
    JAE END_OF_OUTER_LOOP   ; i < A_rows ?

    MOV DWORD PTR [EBP-8],0 ; j = 0
MIDDLE_LOOP:
    MOV EAX, [EBP-8]        ; j
    CMP EAX, [EBP+28]
    JAE END_OF_MIDDLE_LOOP  ; j < B_cols ?

    MOV DWORD PTR [EBP-12],0 ; k = 0
    XOR ECX, ECX             ; SUM = 0
INNER_LOOP:
    MOV EAX, [EBP-12]       ; k
    CMP EAX, [EBP+24]       
    JAE END_OF_INNER_LOOP   ; k < A_cols ?

    ;A[i][k]
    ;--------------------------------
    MOV EAX, [EBP-4]        ; i
    MUL DWORD PTR [EBP+24]  ; i * A_cols
    ADD EAX, [EBP-12]       ; +k
    SHL EAX, 1
    SHL EAX, 1              ; dword olduðundan 4 ile çarptýk

    MOV ESI, [EBP+8]        ; A dizisi
    ADD ESI, EAX            ; ESI -> A[i][k]
    MOV EBX, [ESI]          ; EBX = A[i][k]


    ;B[k][j]
    ;---------------------------------
    MOV EAX, [EBP-12]       ; k
    MUL DWORD PTR [EBP+28]  ; k * B_cols
    ADD EAX, [EBP-8]        ; +j
    SHL EAX, 1
    SHL EAX, 1              ; dword olduðundan 4 ile çarptýk
    
    MOV ESI, [EBP+12]       ; B dizisi
    ADD ESI, EAX            ; ESI -> B[k][j]
    MOV EAX, [ESI]          ; EAX = B[k][j]

    IMUL EBX                ; EAX = A[i][k] * B[k][j]         

    ;ECX = SUM
    ADD ECX, EAX            ; SUM = SUM + A[i][k] * B[k][j]


    INC DWORD PTR [EBP-12]  ; k++
    JMP INNER_LOOP

END_OF_INNER_LOOP:

    ;C[i][j]
    ;---------------------------------
    MOV EAX, [EBP-4]        ; i
    MUL DWORD PTR [EBP+28]  ; i * B_cols
    ADD EAX, [EBP-8]        ; +j
    SHL EAX, 1
    SHL EAX, 1              ; dword olduðundan 4 ile çarptýk

    MOV ESI, [EBP+16]       ; C dizisi
    ADD ESI, EAX            ; ESI -> C[i][j]
    MOV [ESI], ECX          ; C[i][j] = SUM



    INC DWORD PTR [EBP-8]   ; j++
    JMP MIDDLE_LOOP

END_OF_MIDDLE_LOOP:
    INC DWORD PTR [EBP-4]   ; i++
    JMP OUTER_LOOP

END_OF_OUTER_LOOP:
    POP EDX
    POP ECX
    POP EBX
    POP ESI
    POP EAX
    POP EAX
    POP EAX
    POP EBP

    ret
matmul_asm ENDP

END
