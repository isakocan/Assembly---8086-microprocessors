            EXTRN IS_SORTED:FAR
            EXTRN BINARY_SEARCH:FAR

; --- READ_ARRAY ve PRINT_ARRAY makroları ---
READ_ARRAY  MACRO array_name, array_size
            LOCAL R_LOOP, R_PROMPT
            PUSH AX
            PUSH CX
            PUSH SI
            PUSH DX                     

            MOV CX, array_size
            XOR SI, SI
R_LOOP:
            ; Ekrana "1. sayi: " gibi yazdirmak icin
            PUSH AX
            PUSH DX
            PUSH BX                     
            MOV AX, SI                  
            MOV BX, 2
            XOR DX, DX
            DIV BX                      
            INC AX                 
            CALL PUTN
            MOV AL, '.'
            CALL PUTC
            MOV AL, ' '
            CALL PUTC
            POP BX
            POP DX
            POP AX
            
            CALL GETN                   ; Sayıyı oku
            MOV array_name[SI], AX      ; Diziye yaz

            ADD SI, 2                   
            LOOP R_LOOP

            POP DX
            POP SI
            POP CX
            POP AX
            ENDM

PRINT_ARRAY MACRO array_name, array_size
            LOCAL P_LOOP, P_SPACE
            PUSH AX
            PUSH CX
            PUSH SI
            PUSH DX                     

            MOV CX, array_size
            XOR SI, SI
P_LOOP:
            MOV AX, array_name[SI]
            CALL PUTN
            
P_SPACE:
            PUSH AX
            MOV AL, ' '                 
            CALL PUTC
            POP AX
            
            ADD SI, 2
            LOOP P_LOOP

            POP DX
            POP SI
            POP CX
            POP AX
            ENDM
; --- Makroların sonu ---

my_ss       SEGMENT PARA STACK 'stack'
            DW 100 DUP(?)
my_ss       ENDS


my_ds       SEGMENT PARA 'data'

NUMBER_LIST DW 10 DUP(?)
NUMBER_COUNT DW 10
KEY DW ?
RESULT_INDEX DW ?
IS_SORTED_FLAG DW 1

; --- YAZDIRMA KISMI İÇİN MESAJLAR ---
MSG_GIRIS   DB 'Sirali diziyi giriniz:', 13, 10, 0
MSG_DIZI    DB 'Girilen Dizi: ', 0
MSG_SORT_OK DB 'Dizi SIRALI. Arama yapilabilir.', 13, 10, 0
MSG_SORT_ER DB 'HATA: Dizi SIRALI DEGIL! Program sonlandiriliyor.', 13, 10, 0
MSG_ASK_KEY DB 13, 10, 'Aranacak Key degerini girin (Cikis icin q): ', 0
MSG_FOUND   DB ' -> Deger bulundu! Indeks: ', 0
MSG_NOT_F   DB ' -> Deger bulunamadi (-1).', 0
MSG_BYE     DB 13, 10, 'Program sonlandi.', 0
CRLF        DB 13, 10, 0
; --- MESAJLARIN SONU ---

my_ds       ENDS


my_cs       SEGMENT PARA 'code'
            ASSUME CS:my_cs, DS:my_ds, SS:my_ss
main        PROC FAR

            PUSH DS
            XOR AX, AX
            PUSH AX
            MOV AX, my_ds
            MOV DS, AX

            ; --- Diziyi Okur ve Yazdırır ---
            MOV AX, OFFSET MSG_GIRIS
            CALL PUT_STR
            READ_ARRAY NUMBER_LIST, NUMBER_COUNT
            MOV AX, OFFSET MSG_DIZI
            CALL PUT_STR
            PRINT_ARRAY NUMBER_LIST, NUMBER_COUNT
            MOV AX, OFFSET CRLF
            CALL PUT_STR
            ; --- Diziyi Okur ve Yazdırır ---

            ; IS_SORTED(Dizi, n) 
            LEA DI, NUMBER_LIST
            MOV CX, NUMBER_COUNT
            XOR AX, AX
            PUSH AX
            PUSH DI     ; Dizi
            PUSH CX     ; n
            
            CALL IS_SORTED

            POP AX      ;RETURN
            MOV IS_SORTED_FLAG, AX
            CMP AX, 1
            JE SORTED
            ; IS_SORTED

            ; Sıralı değil mesajı
            MOV AX, OFFSET MSG_SORT_ER
            CALL PUT_STR
            JMP EXIT_PROGRAM
            ; Sıralı değil mesajı

SORTED:     ; Sıralı mesajı
            MOV AX, OFFSET MSG_SORT_OK
            CALL PUT_STR
            ; Sıralı mesajı


SEARCH_LOOP:
            ; KEY girdisi mesajı
            MOV AX, OFFSET MSG_ASK_KEY
            CALL PUT_STR
            ; Key girdisi mesajı
            
            ; Key = 'q' kontrolü
            CALL GET_KEY_OR_QUIT
            JC  EXIT_PROGRAM    ; Carry flag = 1 ise bitirir.
            ; Key = 'q' kontrolü

            MOV KEY, AX

            ; BINARY_SEARCH(Dizi, low, high, key)
            LEA DI, NUMBER_LIST
            XOR AX, AX
            MOV CX, NUMBER_COUNT
            DEC CX
            PUSH AX     ;RESULT_INDEX
            PUSH DI     ;Dizi
            PUSH AX     ;LOW
            PUSH CX     ;HIGH
            PUSH KEY    ;KEY
            
            CALL BINARY_SEARCH

            POP AX      ;RETURN
            MOV RESULT_INDEX, AX
            ; BINARY_SEARCH

            ;Sonucu yazdır
            CMP AX, -1
            JE NOT_FOUND

            MOV AX, OFFSET MSG_FOUND
            CALL PUT_STR
            MOV AX, RESULT_INDEX
            CALL PUTN
            JMP SEARCH_LOOP_END

NOT_FOUND:  MOV AX, OFFSET MSG_NOT_F
            CALL PUT_STR
            ;Sonucu yazdır

SEARCH_LOOP_END:
            JMP SEARCH_LOOP
            

EXIT_PROGRAM:     
            MOV AX, OFFSET MSG_BYE
            CALL PUT_STR

            RETF
main        ENDP


; key = 'q' olursa CF = 1 yapar.
GET_KEY_OR_QUIT PROC NEAR
        PUSH BX
        PUSH CX
        PUSH DX

        XOR CX, CX      
        XOR BX, BX      

        ; İlk karakteri okur
        MOV AH, 1h
        INT 21H
        
        ; Çıkış kontrolü
        CMP AL, 'q'     
        JE  QUIT_SIGNAL
        CMP AL, 'Q'     
        JE  QUIT_SIGNAL

        ; q değilse normal sayı okur
        JMP PROCESS_FIRST_CHAR

READ_LOOP_K:
        MOV AH, 1h
        INT 21H
        
PROCESS_FIRST_CHAR:
        CMP AL, 13      
        JE  FINISH_READ_K
        
        SUB AL, '0'     
        MOV BL, AL     
        MOV AX, 10      
        MUL CX        
        MOV CX, AX     
        ADD CX, BX    
        JMP READ_LOOP_K 

QUIT_SIGNAL:
        STC             ; CF = 1 
        JMP END_GK

FINISH_READ_K:
        MOV AX, CX      ; Sonuç AX'te
        CLC             ; CF = 0

END_GK:
        POP DX
        POP CX
        POP BX
        RET
GET_KEY_OR_QUIT ENDP


; --- YARDIMCI I/O YORDAMLARI (ornek25-8.1.asm) ---

GETC    PROC NEAR
        MOV AH, 1h
        INT 21H
        RET 
GETC    ENDP

PUTC    PROC NEAR
        PUSH AX
        PUSH DX
        MOV DL, AL
        MOV AH, 2
        INT 21H
        POP DX
        POP AX
        RET 
PUTC    ENDP

PUT_STR PROC NEAR
        PUSH BX 
        MOV BX, AX
PUT_LOOP:   
        CMP BYTE PTR [BX], 0
        JE  PUT_FIN 
        MOV AL, [BX]
        CALL PUTC 
        INC BX 
        JMP PUT_LOOP
PUT_FIN:
        POP BX
        RET 
PUT_STR ENDP

GETN    PROC NEAR
        PUSH BX
        PUSH CX
        XOR CX, CX     
NEW_HAN:
        MOV AH, 1h  
        INT 21H  
        CMP AL, 13   
        JE  FIN_READ   
        SUB AL, '0'     
        MOV BL, AL     
        MOV AX, 10      
        MUL CX        
        MOV CX, AX     
        ADD CX, BX     
        JMP NEW_HAN 
FIN_READ:
        MOV AX, CX     
        POP CX
        POP BX
        RET 
GETN    ENDP

PUTN    PROC NEAR
        PUSH CX
        PUSH DX
        ; Negatif sayı kontrolü (Binary Search -1 dönebilir)
        CMP AX, 0
        JGE POSITIVE_NUM
        ; Sayı negatifse '-' bas
        PUSH AX
        MOV AL, '-'
        CALL PUTC
        POP AX
        NEG AX
POSITIVE_NUM:
        XOR DX, DX
        PUSH DX        
        MOV CX, 10
CALC_DIGITS:
        XOR DX, DX
        DIV CX         
        ADD DX, '0'     
        PUSH DX       
        XOR DX, DX
        CMP AX, 0    
        JNE CALC_DIGITS
DISP_LOOP:
        POP AX        
        CMP AX, 0      
        JE  END_DISP_LOOP
        CALL PUTC      
        JMP DISP_LOOP
END_DISP_LOOP:
        POP DX 
        POP CX
        RET
PUTN    ENDP

my_cs       ENDS
            END main