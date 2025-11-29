            EXTRN IS_PRIME:FAR
            EXTRN FACTORIZE:FAR
            EXTRN MAX_FACTOR:FAR
            
            PUBLIC FACTORS, FACT_COUNT, NUMBER_LIST, MAX_FACTOR_RESULT

; --- READ_ARRAY ve PRINT_ARRAY makroları ---
READ_ARRAY  MACRO array_name, array_size
            LOCAL R_LOOP, R_PROMPT
; 'array_name' dizisine 'array_size' adet sayıyı klavyeden okur.
; 'array_size' bir değişkenden (DW) okunmalıdır.
            PUSH AX
            PUSH CX
            PUSH SI
            PUSH DX                     

            MOV CX, array_size
            XOR SI, SI
R_LOOP:
            ; --- Kullanıcıya hangi sayıyı girdiğini söyler (1., 2., ...) ---
R_PROMPT:
            PUSH AX
            PUSH DX
            PUSH BX                     
            
            MOV AX, SI                  
            MOV BX, 2
            XOR DX, DX
            DIV BX                      
            ADD AL, '1'                 
            CALL PUTC
            
            MOV AL, '.'
            CALL PUTC
            MOV AL, ' '
            CALL PUTC
            
            POP BX
            POP DX
            POP AX
            ; --- INPUT sonu ---

            CALL GETN                   ; Sayıyı oku (Sonuç AX'te)
            MOV array_name[SI], AX      ; Sayıyı diziye yaz
            
            ; --- Okumadan sonra satır atlar (CR/LF) ---
            PUSH AX
            MOV AL, 13                  
            CALL PUTC
            MOV AL, 10                  
            CALL PUTC
            POP AX
            ; --- Satır atlama sonu ---

            ADD SI, 2                   
            LOOP R_LOOP

            POP DX
            POP SI
            POP CX
            POP AX
            ENDM

PRINT_ARRAY MACRO array_name, array_size
            LOCAL P_LOOP, P_SPACE
; 'array_name' dizisinin 'array_size' adet elemanını ekrana basar.
; 'array_size' bir değişkenden (DW) okunmalıdır.
            PUSH AX
            PUSH CX
            PUSH SI
            PUSH DX                     

            MOV CX, array_size
            XOR SI, SI
P_LOOP:
            MOV AX, array_name[SI]      ; AX = dizi[i]
            CALL PUTN                   ; Sayıyı (AX) bas
            
P_SPACE:
            ; --- Sayılar arasına boşluk koyar ---
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
            DW 20 DUP(?)
my_ss       ENDS


my_ds       SEGMENT PARA 'data'

NUMBER_LIST DW 9 DUP(?)
NUMBER_COUNT DW 9
FACTORS DW 16 DUP(?)
FACT_COUNT DW ?
IS_PRIME_FLAG DW 0
MAX_FACTOR_RESULT  DW ?

; --- YAZDIRMA KISMI İÇİN MESAJLAR ---
CRLF        DB 13, 10, 0                
MSG_OKUNAN  DB 'Okunan Dizi: ', 0
MSG_ASAL    DB ' -> ASALDIR. (En buyuk carpan: ', 0
MSG_ASAL_DEGIL DB ' -> ASAL DEGILDIR.', 0
MSG_CARPANLAR  DB ' Carpanlar: ', 0
MSG_MAX_CARPAN DB ' (En buyuk carpan: ', 0
MSG_KAPAT     DB ')', 0
MSG_BELOW_TWO DB ' -> ASAL DEGILDIR (0 veya 1 durumu).', 0
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
            READ_ARRAY NUMBER_LIST, NUMBER_COUNT
            MOV AX, OFFSET MSG_OKUNAN
            CALL PUT_STR
            PRINT_ARRAY NUMBER_LIST, NUMBER_COUNT
            MOV AX, OFFSET CRLF     
            CALL PUT_STR
            MOV AX, OFFSET CRLF     
            CALL PUT_STR

            
            MOV CX, NUMBER_COUNT ; Loop sayacı
            XOR SI, SI           ; Dizi indisi
ARRAY_LOOP:         
            ; --- Dizi[i] yazdırır ---
            PUSH AX
            MOV AX, NUMBER_LIST[SI]
            CALL PUTN
            POP AX
            
            ; --- BX = dizi[i] (IS_PRIME için parametre) ---
            ; --- IS_PRIME sonucu AX ile döndürür ---
            PUSH BX
            MOV BX, NUMBER_LIST[SI]  
            CALL IS_PRIME
            POP BX

            ; --- Sayı: 1 ya da 0 ise AX(flag) 2 OLUR (ÖZEL DURUM) ---
            CMP AX, 2
            JE BELOW_TWO 

            MOV IS_PRIME_FLAG, AX
            CMP AX, 0
            JNE PRIME
            
            ; --- Sayı Asal Değilse çarpanlarına ayırır ---
            CALL FACTORIZE

            PUSH DI
            MOV  DI, FACT_COUNT
            CALL MAX_FACTOR
            POP DI
            
            ; --- Asal Değil durumu için sonuçları yazdırır ---
            PUSH AX
            MOV AX, OFFSET MSG_ASAL_DEGIL
            CALL PUT_STR
            MOV AX, OFFSET MSG_CARPANLAR
            CALL PUT_STR
            PRINT_ARRAY FACTORS, FACT_COUNT
            MOV AX, OFFSET MSG_MAX_CARPAN
            CALL PUT_STR
            MOV AX, MAX_FACTOR_RESULT
            CALL PUTN
            MOV AX, OFFSET MSG_KAPAT
            CALL PUT_STR
            POP AX

            JMP ITER_DONE

PRIME:      ; --- Sayı Asal ise sonuçları yazdırır ---
            ; --- En buyuk carpan sayinin kendisi olur ---
            MOV AX, NUMBER_LIST[SI]
            MOV MAX_FACTOR_RESULT, AX 

            MOV AX, OFFSET MSG_ASAL
            CALL PUT_STR
            MOV AX, MAX_FACTOR_RESULT
            CALL PUTN
            MOV AX, OFFSET MSG_KAPAT
            CALL PUT_STR

            JMP ITER_DONE

BELOW_TWO: ; --- Sayı 0 veya 1 ise bilgilendirme mesajı---
            MOV AX, OFFSET MSG_BELOW_TWO
            CALL PUT_STR


ITER_DONE:  ; --- Her sayıdan sonra satır atla ---
            PUSH AX
            MOV AX, OFFSET CRLF
            CALL PUT_STR
            POP AX

            ADD SI, 2 ; Dizi indisini 2 artır (DW)

            ; --- LOOP çok uzun olduğu için jump kullanıyoruz. ---
            DEC CX
            CMP CX, 0
            JE END_OF_LOOP
            JMP ARRAY_LOOP
END_OF_LOOP:            
            
            RETF
main        ENDP



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
        CALL GETC       
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
        XOR DX, DX
        PUSH DX         
        MOV CX, 10
CALC_DIGITS:
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