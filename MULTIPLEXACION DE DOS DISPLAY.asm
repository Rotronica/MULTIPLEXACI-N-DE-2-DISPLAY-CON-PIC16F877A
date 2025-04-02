;Autor: Calle Condori Rodrigo
;EJERCICIO 1:Realizar un contador del 0 al 99 utilizando 2 display de 7 segmentos cátodo común.  
   __CONFIG _XT_OSC & _WDTE_OFF & _PWRTE_ON & _CP_OFF & _BOREN_OFF & _LVP_OFF
   LIST  P=16F877A
   INCLUDE <P16F877A.INC>
;VARIABLES
   CBLOCK 0X20
   UNIDAD
   DECENA
   CONT1
   CONT2
   AUX
   ENDC
;DEFINICION DE PINES
   #DEFINE   DISPLAY1   PORTA,0   
   #DEFINE   DISPLAY2   PORTA,1

                     ORG  0X00
                     GOTO CONFIGURAR

CONFIGURAR:
                     BSF   STATUS, RP0 ; Select Bank 1
                     MOVLW 0x06      ; Configure all pins
                     MOVWF ADCON1    ; as digital inputs   
                     BCF   TRISA,RA0
					 BCF   TRISA,RA1
                     CLRF  TRISB
                     BCF   STATUS,RP0
                     CLRF  PORTB
                     CLRF  UNIDAD
                     CLRF  DECENA
;-----------------------------------------
MAIN:
                     CALL  VISUALIZAR     ;LLAMA A LA SUBRUTINA VISUALIZAR
                     CALL  INTERNO        ;LLAMA A LA SUBRUTINA INTERNO
                     GOTO  MAIN           ;CIERRA EL BUCLE PRINCIPAL
;-----------------------------------------
VISUALIZAR:                     
;UNIDADES 
                     BSF   DISPLAY1       ;EL DISPLAY1 SE ENCIENDE 
                     BCF   DISPLAY2       ;EL DISPLAY2 ESTÁ APAGADO
                     MOVF  UNIDAD,W       ;MOVEMOS EL CONTENIDO DE LA DEL REGISTRO UNIDAD
                     CALL  TABLA          ;HACE UN LLAMADO A LA SUBRUTINA TABLA
                     MOVWF PORTB          ;MOVER EL REGITRO DE TRABAJO AL REGISTRO PORTB
                     CALL  RETARDO        ;RETADOR FPS PARA LA VISUALIZACION DE DISPLAY
;DECENAS
                     BCF   DISPLAY1       ;EL DISPLAY1 SE APAGA
                     BSF   DISPLAY2       ;EL DISPLAY2 SE ENCIENE
                     MOVF  DECENA,W       ;MOVER EL REGISTRO DECENA AL REGISTRO 'W'
                     CALL  TABLA          ;LLAMADA A LA SUBRUTINA TABLA
                     MOVWF PORTB          ;MOVER EL REGISTRO DE TRABAJO AL REGISTRO PORTB
                     CALL  RETARDO        ;LLAMADA A SUBRUTINA
                     RETURN               ;RETORNO DE LA SUBRUTINA
TABLA:
                     ADDWF    PCL,F       ;REALIZA LA SIGUIENTE OPEACIÓN PCL=PCL+W
                     RETLW    0X3F        ;RETORNA EN 'W' CON UN VALOR 0
                     RETLW    0X06        ;RETORNA EN 'W' CON UN VALOR 1
                     RETLW    0X5B        ;RETORNA EN 'W' CON UN VALOR 2
                     RETLW    0X4F        ;RETORNA EN 'W' CON UN VALOR 3
                     RETLW    0X66        ;RETORNA EN 'W' CON UN VALOR 4
                     RETLW    0X6D        ;RETORNA EN 'W' CON UN VALOR 5
                     RETLW    0X7D        ;RETORNA EN 'W' CON UN VALOR 6
                     RETLW    0X07        ;RETORNA EN 'W' CON UN VALOR 7
                     RETLW    0X7F        ;RETORNA EN 'W' CON UN VALOR 8
                     RETLW    0X6F        ;RETORNA EN 'W' CON UN VALOR 9
INTERNO:
;PARA PODER MANTENER LA VISUALIZACION EN EL DISPLAY----------------------
                     INCF     AUX,F       ;INCREMENTAMOS LA VARIABLE AUX
                     MOVLW    .50         ;MOVER EL VALOR 50 AL REGISTRO 'W'
                     SUBWF    AUX,W       ;SUBSTRAER EL REGISTRO 'W' DEL REGISTRO AUX W=AUX-W
                     BTFSS    STATUS,Z    ;SALTA UNA INSTRUCCIÓN SI LA BANDERA 'Z' ESTA EN 1 LOGICO
                     RETURN               ;EJECUTA LA INSTRUCCIÓN RETURN CUANDO 'Z' NO ESTA EN 1 LOGICO
;------------------------------------------------------------------------
              
;PARA LAS UNIDADES
                     CLRF    AUX          ;LIMPIAR LA VARIABLE AUX
                     INCF    UNIDAD,F     ;INCREMENTAR EL REGISTRO UNIDAD (UNIDAD=UNIDAD+1)
                     MOVLW   .10          ;MOVER EL LITERAL 10 AL REGISTRO 'W'
                     SUBWF   UNIDAD,W     ;SUBSTRAER EL REGISTRO 'W' DEL REGISTRO UNIDAD
                     BTFSS   STATUS,Z     ;SALTA SI LA BANDERA 'Z' ESTÁ EN 1 LÓGICO
                     RETURN               ;RETORNA SI LA BANDERA 'Z' NO ESTÁ A 1 LÓGICO
                     
;PARA LAS DECENAS
                     CLRF    UNIDAD       ;LIMPIAMOS EL REGISTRO UNIDAD, PARA PODDER REALIZAR NUEVAMENTE EL CONTEO DE UNIDADES
                     INCF    DECENA,F     ;SE INCREMENTA LAS DECENAS
                     MOVLW   .10          ;LIMITE DE LAS DECENAS REALIZA EL CONTEO HASTA 9, MAS EL 0 SON 10
                     SUBWF   DECENA,W     ;RESTA EL LIMITE CON EL REGISTRO DECENA
                     BTFSS   STATUS,Z     ;SALTA SI LA BANDERA 'Z' ESTÁ EN 1 LÓGICO
                     RETURN               ;RETORNA SI LA BANDERA 'Z' NO ESTÁ A 1 LÓGICO

                     CLRF    UNIDAD       ;REINICIAMOS EL CONTADOR 
                     CLRF    DECENA
                     RETURN
;----------------RETARDO PARA 5MS-------------------
RETARDO:      
                     MOVLW   .16          
                     MOVWF   CONT2
REPETICION2:  
                     MOVLW   .100
                     MOVWF   CONT1
REPETICION1:  
                     DECFSZ  CONT1,F
                     GOTO    REPETICION1
                     DECFSZ  CONT2,F
                     GOTO    REPETICION2      
                     RETURN

                     END