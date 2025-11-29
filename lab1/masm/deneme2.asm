;  MEAN SQUARED ERROR (MSE) HESAPLAMA

STK SEGMENT PARA STACK 'STACK'
        DW 30 DUP(?)
STK ENDS

DSG SEGMENT PARA 'DATA'
        SUM     DD    0         
        MSE     DW    0
        VAR     DB  0FBH   ; 0FBh olmalı             
        D1      DW   10,  1, -3,  7,  0
        D2      DW    5,  5,  8, -6,  9
        N       DW    5
DSG ENDS

CSG SEGMENT PARA 'CODE'
        ASSUME CS:CSG, DS:DSG, SS:STK  ;hepsine CSG yazılmış 
START PROC  FAR  ; FAR ifadesi eksik             

        PUSH  DS
        XOR   AX, AX
        PUSH  AX
        MOV   AX, DSG  ; STK değil DSG olmalı
        MOV   DS, AX   ; bu satır eksik

        XOR   AX, AX
        MOV   WORD PTR [SUM],   AX ; WORD PTR ifadesi eksik.                
        MOV   WORD PTR [SUM+2], AX ; Normalde word boyutunda bir şeyi DD boyutuna atamayız o yüzden ptr gerekir

        LEA   SI, D1
        LEA   DI, D2
        MOV   CX, N           

    CALC_LOOP:
        MOV   AX, [SI]
        MOV   BX, [DI]

        SUB   AX, BX          
        JGE   NONNEG   ;negatif sayılara da bakacağı için jge olmalı                   
        NEG   AX       ; not işareti değiştirmez NEG kullanmalıyız                 
    NONNEG:
        MUL  AX        ; Bx olmaz Ax olmalı, pozitif sayılar olacağı için IMUL'a gerek yok                

        ADD   WORD PTR [SUM],   AX ;WOrd ptr gelmeli  
        ADC   WORD PTR [SUM+2], DX ; ptr gelmeli ve ax toplamından carry oluşabileceği için ADC olmalı             

        ADD   SI, 2       ; word boyutunda oldupundan +2 artmalı              
        ADD   DI, 2       ; aynısı
        LOOP  CALC_LOOP

        MOV   DX, WORD PTR [SUM+2]   ; PTR kullanmalıyız ve +2'lik kısım DX olmalı yüksek adresli taraf olması için                
        MOV   AX, WORD PTR [SUM]     ; aynı şekilde AX'e düşük adres gelmeli
        MOV   CX, n       ; bu satır eksik çünkü Looptan dolayı cx sıfırlanmıştı
        DIV   CX          ; CL değil CX olmalı
        MOV   MSE, AX

    RETF  ; RETF olmalı 
START ENDP
CSG ENDS

END START
