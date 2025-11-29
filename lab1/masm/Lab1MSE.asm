;  MEAN SQUARED ERROR (MSE) HESAPLAMA

STK SEGMENT PARA STACK 'STACK'
        DW 30 DUP(?)
STK ENDS

DSG SEGMENT PARA 'DATA'
        SUM     DD    0         
        MSE     DD    0     ; DD boyutunda olmalı, DW yanlış
        VAR     DB  0FBH    ; başına 0 gelcekmiş sir arda gönüllü          
        D1      DW   10,  1, -3,  7,  0
        D2      DW    5,  5,  8, -6,  9
        N       DW    5
DSG ENDS

CSG SEGMENT PARA 'CODE'
        ASSUME CS:CSG, DS:DSG, SS:STK   ; hepsine CSG yazılmış
START PROC FAR        ; FAR eksik            

        PUSH  DS
        XOR   AX, AX
        PUSH  AX
        MOV   AX, DSG  ; STK ifadesi yanlış DS'yi kaydetmeliyiz.                 
        MOV   DS, AX   ; bu komut eksik. DS'yi güncellemeliyiz.

        XOR   AX, AX
        MOV   [SUM],   AX      ;başlangıçta SUM'ı ds'de 0 yapmıştık zaten gerek yok        
        MOV   [SUM+2], AX      ;

        LEA   SI, D1
        LEA   DI, D2
        MOV   CX, N           

    CALC_LOOP:
        MOV   AX, [SI]
        MOV   BX, [DI]

        SUB   AX, BX          
        JAE   NONNEG                    
        NEG   AX        ; NOT yerine NEG olmalıydı                
    NONNEG:
        MUL  BX         ;  IMUL 'a gerek yok MUL kullanacağız.             

        ADD   [SUM],   AX
        ADC   [SUM+2], DX   ; ADD olmaz çünkü AX toplamından gelen carry olabilir.         

        ADD   SI, 2      ; word boyutunda olduğu için +1 değil +2 eklenir               
        ADD   DI, 2      ; aynı
        LOOP  CALC_LOOP

        MOV   DX, [SUM+2]   ; Yüksek anlamlı kısmı DX'te olmalı o yüzden [SUM+2] burada              
        MOV   AX, [SUM] ; [SUM] burada olmalı
        MOV   CX, N     ; Looptan dolayı cx sıfırlanmıştı. bu satır eksikti.
        DIV   CX        ; n sayısını word belirlemiştik cl yanlış  
        ; MOV   MSE, AX bu satır yanlış çünkü sonuç dd boyutunda
        MOV   [SUM],   AX
        MOV   [SUM+2], DX  
        

    RETF ; F eksik
START ENDP
CSG ENDS

END START
