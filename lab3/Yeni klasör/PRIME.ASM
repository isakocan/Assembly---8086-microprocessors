;------------------------------------------------------------------------
; IS_PRIME: BX yazmacındaki sayının Asal olup olmadığını kontrol eder.
; GİRİŞ:
;   BX = Kontrol edilecek 16-bit sayı (N)
; ÇIKIŞ:
;   AX = 1 (Asal ise)
;   AX = 0 (Asal değilse)
;   AX = 2 (Özel durum: 0 veya 1 ise)
;------------------------------------------------------------------------            
            PUBLIC IS_PRIME

mycode      SEGMENT PARA 'CODE'
            ASSUME CS:mycode
IS_PRIME    PROC FAR

            ; --- Kullanılan yazmaçları yığına (stack) atarak korur ---
            PUSH BX
            PUSH DI
            PUSH DX

            CMP BX, 2
            ; --- Sayı (BX) < 2 mi? (0 YA DA 1 DURUMU)---
            JB BELOW_PRIME 
            ; --- Sayı (BX) == 2 mi? ---         
            JE SET_PRIME

            ; --- Sayı (BX) 2'ye bölünüyor mu? ---
            TEST BX, 1
            JZ NOT_PRIME

            ; --- Sayı 3'ten büyük ve TEK ise döngüye gir ---
            MOV DI, 3
PRIME_LOOP: MOV AX, DI
            MUL AX          ; --- (Bölen * Bölen) > Sayı mı? (DI*DI > BX) ---
            CMP DX, 0
            JNE SET_PRIME
            CMP AX, BX
            JA END_OF_LOOP

            MOV AX, BX
            XOR DX, DX
            DIV DI          ; --- Sayı (BX) / Bölen (DI) tam bölünüyor mu? ---
            CMP DX, 0
            JZ NOT_PRIME
            ADD DI, 2       ; --- Sonraki tek böleni dener ---
            JMP PRIME_LOOP

END_OF_LOOP:    
            JMP SET_PRIME   ; --- Karekök aşıldı -> Asaldır

NOT_PRIME:  XOR AX, AX      ; --- Asal değil. AX=0 ---
            JMP FINISH
BELOW_PRIME:
            MOV AX, 2       ; --- 0 ya da 1 durumu AX=2 ---
            JMP FINISH
            
SET_PRIME:  MOV AX, 1       ; --- Asaldır. AX=1 ---


FINISH:     POP DX
            POP DI
            POP BX
            RETF
IS_PRIME    ENDP
mycode      ENDS
            END