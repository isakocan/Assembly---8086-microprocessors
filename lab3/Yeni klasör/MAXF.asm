;------------------------------------------------------------------------
; MAX_FACTOR: 'FACTORS' dizisindeki en büyük asal çarpanı bulur.
; (Dizi sıralı olduğu için bu, dizinin son elemanıdır.)
; GİRİŞ (Register):
;   DI = Toplam çarpan sayısı (FACT_COUNT)
;       -> Dizinin son elemanını alma amacında olduğumuz için DI yazmacını kullandım.
;       -> Çünkü indisle uğraşmış oluyoruz aslında.
; GİRİŞ (Kesimden):
;   FACTORS: Asal çarpanlar dizisi
; ÇIKIŞ (Kesime):
;   MAX_FACTOR_RESULT: Dizinin son elemanı (en büyük çarpan) yazılır
;------------------------------------------------------------------------            
            
            PUBLIC MAX_FACTOR
            EXTRN FACTORS:WORD, MAX_FACTOR_RESULT:WORD

mycode      SEGMENT PARA 'CODE'
            ASSUME CS:mycode
MAX_FACTOR  PROC FAR

            ; --- Kullanılan yazmaçları yığına (stack) atarak korur ---
            PUSH DI
            PUSH DX

            ; --- Son elemanın indisini bul ---
            ; --- DI = FACT_COUNT (Örn: 5) -> DI = DI - 1 (Örn: 4) (Son elemanın indisi) ---
            DEC DI
            ; --- Doğru byte offset'i bul (indis * 2, dizi elemanları WORD olduğundan) ---
            SHL DI, 1

            ; --- Son elemanı oku ve sonucu kaydet ---
            MOV DX, FACTORS[DI]
            MOV MAX_FACTOR_RESULT, DX

            POP DX
            POP DI

            RETF
MAX_FACTOR  ENDP
mycode      ENDS
            END