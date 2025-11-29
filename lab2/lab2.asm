;LAB2
myss SEGMENT PARA STACK 'stack'
        DW 20 DUP(?)
myss ENDS

myds SEGMENT PARA 'data'
        SUM DW 0                ;50 -> 32H
        MEAN DW ?               ;7
        COUNTER DW 0            ;5
        N DW 7
        CELCİUS DW 0, 11, -273, 72, 100, 27, -33
        FAHRENHEİT DW 7 DUP(?)  ;32, 51, -459, 161, 212, 80, -27
myds ENDS

mycs SEGMENT PARA 'code'
        ASSUME SS: myss, DS: myds, CS: mycs
MAİN PROC FAR
        PUSH DS
        XOR AX, AX
        PUSH AX
        MOV AX, myds
        MOV DS, AX

        MOV CX, N               
        LEA SI, CELCİUS         
        LEA DI, FAHRENHEİT
        MOV BX, 5               ;DAHA VERİMLİ OLSUN DİYE REGİSTER'A ATADIM

        FAHRENHEIT_LOOP:
        MOV DX, 9               ;BOŞTA KALAN TEK REGİSTER. AYRICA MUL, DIV İŞLEMLERİNDEN DOLAYI 
        MOV AX, [SI]            ;DEĞİŞTİĞİ İÇİN HER TUR ATAMA GEREKİR. AMA BU HALİYLE BİLE DAHA HIZLI
        IMUL DX                 ;IMUL SAYİ -> 134-160+EA / IMUL DX + MOV DX, 9-> 128-154 + 4 CYCLE 
        IDIV BX
        ADD AX, 32

        MOV [DI], AX
        ADD SUM, AX

        ADD SI, 2
        ADD DI, 2
        LOOP FAHRENHEIT_LOOP

        MOV AX, SUM
        XOR DX, DX              ;DX SIFIRLAMALIYIZ ÇÜNKÜ EN SONKİ BÖLME İŞLEMİNİN KALANI YAZILDI
        MOV CX, N               ;LOOP İÇİN CX'E N DEĞERİNİ YÜKLEYECEKTİK. BURADA YÜKLEYEREK BÖLME İŞLEMİNİ HIZLANDIRDIM.
        IDIV CX                 
        MOV MEAN, AX

        LEA DI, FAHRENHEİT
        XOR BX, BX
        COUNTER_LOOP:
        CMP [DI], AX
        JLE NOT_COUNT           ;BOŞ OLAN FALSE KOLUNDAN ZIPLADIK.
        INC BX                  ;INC COUNTER (7 KERE ÇALIŞIR) -> 105+EA CYCLE OLUR
        NOT_COUNT:              ;XOR BX, BX -> 3 + INC BX (7 KERE) -> 14 + MOV COUNTER, BX -> 9+EA
        ADD DI, 2               ;TOPLAMDA 26 CYCLE. BU YOLLA DAHA VERİMLİ OLUR.
        LOOP COUNTER_LOOP
        MOV COUNTER, BX        


RETF
MAİN ENDP
mycs ENDS

END MAİN