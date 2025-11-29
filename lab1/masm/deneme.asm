;  MEAN SQUARED ERROR (MSE) HESAPLAMA

STK SEGMENT PARA STACK 'STACK'
        DW 30 DUP(?)
STK ENDS

DSG SEGMENT PARA 'DATA'
        SUM     DD    0         
        MSE     DW    0
        ;VAR     DB  FBH bu değişkeni hiç kullanmıyoruz gereksiz ayrıca 0FBh olmalıydı              
        D1      DW   10,  1, -3,  7,  0
        D2      DW    5,  5,  8, -6,  9
        N       DW    5
DSG ENDS

CSG SEGMENT PARA 'CODE'
        ASSUME CS:CSG, DS:DSG, SS:STK   ; hepsine CSG yazılmış
START PROC FAR ; FAR ifadesi eksik                             

        PUSH  DS
        XOR   AX, AX
        PUSH  AX
        MOV   AX, DSG  ; STK değil DSG olmalı                
        MOV   DS, AX   ; bu satır eksik 

        ; XOR   AX, AX   
        ; MOV   [SUM],   AX               
        ; MOV   [SUM+2], AX   SUM değerini başlangıçta 0 tanımladık zaten gereksiz

        LEA   SI, D1
        LEA   DI, D2
        MOV   CX, n           

    CALC_LOOP:
        MOV   AX, [SI]
        MOV   BX, [DI]

        SUB   AX, BX          
        ; JAE   NONNEG                    
        ; NOT   AX                        
    ; NONNEG: IMUL kullanıyoruz zaten bu 3 satır gereksiz
        IMUL  AX   ; AX olmalı çünkü çıkarma işleminin sonucu orada                        

        ADD   WORD PTR [SUM],   AX  ; SUM'ın boyutu fazla olduğu için derleyiciye ne kadarını kullanacağımızı söylüyoruz.
        ADC   WORD PTR [SUM+2], DX  ; ADC olmalı çünkü AX toplama işleminde carry oluşabilir               

        ADD   SI, 2      ; diziyi WORD tanımladığımız için +2 artmalı               
        ADD   DI, 2      ; Aynısı geçerli
        LOOP  CALC_LOOP

        MOV   AX, WORD PTR [SUM]   ; düşük anlamlı kısım AX olmalı                
        MOV   DX, WORD PTR [SUM+2] ; yüksek anlamlı kısım DX olmalı
        MOV   CX, n       ; Looptan dolayı cx sıfırlanmıştı
        DIV   CX       ; CL değil CX olmalı                 
        MOV   MSE, AX

    RETF ; F harfi eksik 
START ENDP
CSG ENDS

END START  
