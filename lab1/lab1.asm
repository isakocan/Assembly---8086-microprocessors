;  MEAN SQUARED ERROR (MSE) HESAPLAMA

STK SEGMENT PARA STACK 'STACK'
            DW 30 DUP(?)
STK ENDS

DSG SEGMENT PARA 'DATA'
        SUM DD 0
        MSE DW 0
        VAR DB 0FBH                      ;Sayılar harf ile başlayamaz. 0FBh olmalı.
        D1  DW 10,  1, -3,  7,  0
        D2  DW 5,  5,  8, -6,  9
        N   DW 5
DSG ENDS

CSG SEGMENT PARA 'CODE'
                  ASSUME CS:CSG, DS:DSG, SS:STK        ;Hepsine CSG yazılmış. Kendi segmentlerini yazdım.
START PROC FAR                                         ;FAR ifadesi eksikti. Main PROC, FAR olmalı.

                  PUSH   DS
                  XOR    AX, AX
                  PUSH   AX
                  MOV    AX, DSG                       ;STK değil DSG olmalı. STK, DOS tarafından otomatik yapılır.
                  MOV    DS, AX                        ;Bu satır eksikti. DSG'yi DS'ye yüklemeliyiz.

                  XOR    AX, AX
                  MOV    WORD PTR [SUM],   AX          ;WORD PTR ifadesi eksik. SUM'ın boyutu 4 byte iken AX'in boyutu 2 byte'dır.
                  MOV    WORD PTR [SUM+2], AX          ;Aynı hata.

                  LEA    SI, D1
                  LEA    DI, D2
                  MOV    CX, N

        CALC_LOOP:
                  MOV    AX, [SI]
                  MOV    BX, [DI]

                  SUB    AX, BX
                  JGE    NONNEG                        ;Negatif sayılara da bakabileceği için JGE olmalıdır.
                  NEG    AX                            ;NOT işareti değiştirmez. NEG kullanmalıyız.
        NONNEG:   
                  MUL    AX                            ;Bx olmaz. Ax olmalı, pozitif sayılar olacağı için IMUL'a gerek yok.

                  ADD    WORD PTR [SUM],   AX          ;WORD PTR gelmeli.
                  ADC    WORD PTR [SUM+2], DX          ;WORD PTR gelmeli ve Ax toplamından carry oluşabileceği için ADC olmalı.

                  ADD    SI, 2                         ;Dizinin elemanları WORD boyutunda olduğundan indisler +2 artmalı.
                  ADD    DI, 2                         ;Aynı hata
                  LOOP   CALC_LOOP

                  MOV    DX, WORD PTR [SUM+2]          ;WORD PTR gelmeli ve +2'lik kısım DX olmalı yüksek adresli taraf olması için
                  MOV    AX, WORD PTR [SUM]            ;Aynı şekilde AX'e düşük adres gelmeli
                  MOV    CX, n                         ;Bu satır eksik çünkü LOOP'tan dolayı Cx sıfırlanmıştı.
                  DIV    CX                            ;CL değil CX olmalı.
                  MOV    MSE, AX

                  RETF                                 ;RETF olmalı
START ENDP
CSG ENDS

END START
