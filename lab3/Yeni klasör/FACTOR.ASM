;------------------------------------------------------------------------
; FACTORIZE: 'NUMBER_LIST[SI]' adresindeki sayıyı asal çarpanlarına ayırır.
; GİRİŞ (Kesimden):
;   NUMBER_LIST: Sayı dizisi
;   SI: 'main' yordamından gelen ve 'NUMBER_LIST' için indis olan yazmaç
; ÇIKIŞ (Kesime):
;   FACTORS: Doldurulan asal çarpanlar dizisi
;   FACT_COUNT: Bulunan toplam çarpan sayısı
;------------------------------------------------------------------------               

            PUBLIC FACTORIZE
            EXTRN FACTORS:WORD, FACT_COUNT:WORD, NUMBER_LIST:WORD

mycode      SEGMENT PARA 'CODE'
            ASSUME CS:mycode
FACTORIZE   PROC FAR
            ; --- Kullanılan tüm yazmaçları yığına (stack) atarak korur ---
            PUSH AX
            PUSH BX
            PUSH CX
            PUSH DX
            PUSH DI
            PUSH SI

            ; --- 'FACTORS' dizisi için indis ve çarpan sayacını sıfırlama ---
            XOR DI, DI
            MOV FACT_COUNT, 0

            ; --- Sayımız (AX) ve ilk potansiyel çarpan (BX=2)
            MOV AX, NUMBER_LIST[SI]
            MOV BX, 2

; --- 1. Adım: Tüm '2' Çarpanlarını Ayıkla (Sayı çift olduğu sürece) ---
TWOS_LOOP:  XOR DX, DX
            MOV CX, AX ; --- !ÖNEMLİ: Bölme işlemi öncesi sayıyı kaydetmeliyiz.
            DIV BX     ; --- Eğer çarpan değilse bölünmemiş sayıyla devam etmek isteriz. ---
            CMP DX, 0
            JNZ DONE_FOR_TWO
            MOV FACTORS[DI], 2
            ADD DI, 2
            INC FACT_COUNT
            JMP TWOS_LOOP
            
DONE_FOR_TWO: 
; --- 2. Adım: Tek Çarpanları Ayıkla (Bölen = 3, 5, 7...) ---
            INC BX
FACTOR_LOOP:
            ; --- (Bölen * Bölen) > Sayı mı? ---
            MOV AX, BX
            MUL AX
            CMP DX, 0
            JNE END_OF_LOOP
            CMP AX, CX
            JA END_OF_LOOP
            
            ; --- İç döngüde sayıyı aynı çarpana (BX) bölünebildiği kadar böler. (örn: 27/3, 9/3...) ---
            XOR DX, DX
            MOV AX, CX

INNER_LOOP: DIV BX
            CMP DX, 0
            JNZ NOT_FACTOR

            ; --- Çarpandır. Factors'e ekleriz ---
            MOV FACTORS[DI], BX
            ADD DI, 2
            INC FACT_COUNT
            MOV CX, AX
            JMP INNER_LOOP
            
NOT_FACTOR: ; --- Bu çarpanla işimiz bitti, sonraki. (Örn: 3 -> 5 -> 7) ---       
            ADD BX, 2
            JMP FACTOR_LOOP

END_OF_LOOP:; --- Karekök aşıldı. ---
            ; --- Eğer bölünmüş sayı 1'den büyükse kendisi son çarpandır. Factors'e ekleriz. ---
            ; --- En son sayı 1 olduysa işimiz bitmiştir zaten.
            CMP CX, 1
            JE FINISH
            MOV FACTORS[DI], CX
            INC FACT_COUNT

FINISH:     POP SI
            POP DI
            POP DX
            POP CX
            POP BX
            POP AX
            RETF
FACTORIZE   ENDP
mycode      ENDS
            END