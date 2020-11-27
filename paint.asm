NAME "parcial3"
.model small

data SEGMENT                           
    titulo   DB 10d,13d,"                           MENU                    $"
    linea    DB 10d,13d,"    -----------------------------------------------$"
    opcion1  DB 10d,13d,"    |	1 - Dibuajar a mano alzada.	          |$"     
    opcion2  DB 10d,13d,"    |	2 - Mostrar nombre.	                  |$" 
    opcion3  DB 10d,13d,"    |	3 - Salir.		                       |$"  
    peticion DB 10d,13d,"     Digite el numero de la opcion que necesita[   ]$"   
    error    DB 10d,13d,"    Error, por favor ingrese una opcion valida$"  
    espera   DB "    ...Enter$"  
    opc      DW 0d
    datos    DB 10d,13d,"Josue Ismael Quinteros Ramirez - QR100318$"
ENDS

stack SEGMENT
    dw   128  dup(0)
ENDS

code SEGMENT
start:    
    inicio:      
        ; Mover el inicio del segmento de datos al registro DS y ES a travez de AX
        MOV AX, @data
        MOV DS, AX
        MOV ES, AX 
        
                    
        ; modo de video 40 x 25 , AH=00h y AL=00h
        MOV AH,00h
        MOV AL,03h
        INT 10h  
        

    proceso:  
        CALL limpiar ; Repintal la pantalla con el cuadro azul 
                    
        CALL menu    ; Pintar el menu y pedir la opcion
        
        LEA DX,linea ; Prepara para imprimir linea de separacion
        CALL imprimir; Llamar al procedimiento para imprimir el dato previo preparado
        
        CMP opc,31h  ; Comparar el dato capturado con el codigo ascii del numero 1
        JZ opc1      ; Saltar si los valores previos comparados son iguales, si opc tiene 31h
        
        CMP opc,32h  ; Comparar el dato capturado con el codigo ascii del numero 2
        JZ opc2      ; Saltar si los valores previos comparados son iguales, si opc tiene 32h
        
     
        CMP opc,33h  ; Comparar el dato capturado con el codigo ascii del numero 6
        JZ terminar  ; Saltar si los valores previos comparados son iguales, si opc tiene 36h
                   
                   
        LEA DX,error ; Prepara para imprimir mensaje de error
        CALL imprimir; Llamar al procedimiento para imprimir el dato previo preparado
        CALL esperar ; Llamar al procedimiento para esperar la pulsacion de una tecla para continuar
        JMP proceso  ;
    
        opc1:
             
            
            ;MODO PAINT
            MOV AL, 12h
            MOV AH, 0   
            INT 10h   
                       
            ;MOSTRAR CURSOR          
            MOV AX, 1   
            INT 33h
            
            PROCESAR: 
            
                MOV AX, 3   
                INT 33h
                       
                ; BLANCO
                MOV AL,1111b 
                      
                CMP BX,1
                JZ red
                
                CMP BX,2
                JZ yellow 
                   
                MOV AH, 0ch    
                SHR CX,1    
                INT 10h
                 
            JMP PROCESAR
            
            
 
            YELLOW:  
                MOV AL, 1110b  
                MOV AH, 0ch    
                SHR CX,1    
                INT 10h
                JMP PROCESAR
            RED: 
                MOV AL, 0100b
                MOV AH, 0ch    
                SHR CX,1    
                INT 10h 
                JMP PROCESAR   

                        
        opc2: 
        
           
           
            MOV al, 1
        	MOV bh, 0
        	MOV bl, 1111_0100b
        	MOV cx, 43d  
        	MOV bp, offset datos 
        	MOV dl,20h
        	MOV dh, 9h
        	MOV ah, 13h
        	INT 10h
        	

    
        terminar:
            ;Esperar que se presiones una tecla para seguir.  
            CALL esperar   
            ;Terminar el programa.
            MOV AX, 4C00h 
            INT 21h   
     
        ;Creacion de un procedimiento.
        limpiar PROC NEAR
            MOV AH,06h          ; Peticion para limpiar pantalla   
            MOV AL,00h          ; Peticion para limpiar pantalla
            MOV BH,0000_1111b    ; Color fondo=0 "Negro"Color de letra=F "Blanco"
            MOV CX,0101h        ; Se posiciona el cursor en Ren=0 Col=0
            MOV DX,174Eh        ; Se posiciona el cursor al final de la pantalla Ren=17(18h) Col=79(4Fh)
            INT 10h             ; INTERRUPCION AL BIOS   
            
            MOV DH, 2d
        	MOV DL, 2d
        	MOV BH, 0h
        	MOV AH, 2h
        	INT 10h
            RET
        limpiar ENDP 
        
        imprimir PROC NEAR
            MOV AH,09
            INT 21h
            RET
        imprimir ENDP    
    
        esperar PROC NEAR 
            LEA DX,espera
            CALL imprimir
            MOV AH, 07h
            INT 21h  
            RET 
        esperar ENDP
    
        teclado PROC NEAR
            MOV AH, 01h
            INT 21h  
            RET 
        teclado ENDP
    
        menu PROC NEAR  
            ;Imprimir la linea de apertura del menu             
            LEA DX,titulo
            CALL imprimir 
             
            ;Imprimir la linea de apertura del menu             
            LEA DX,linea
            CALL imprimir            
            
            ;Imprimir la opcion 1 del menu           
            LEA DX,opcion1
            CALL imprimir  
            
            ;Imprimir la opcion 2 del menu           
            LEA DX,opcion2
            CALL imprimir          
            
            ;Imprimir la opcion 3 del menu              
            LEA DX,opcion3
            CALL imprimir         
            
            
            ;Imprimir la linea de apertura del menu             
            LEA DX,linea
            CALL imprimir             
            
            ;Imprimir la linea de peticion de opcion           
            LEA DX,peticion
            CALL imprimir    
            
            MOV AH, 02h
            MOV DH, 9d
        	MOV DL, 49d
        	MOV BH, 0
        	INT 10h
            
            CALL teclado
            XOR AH,AH
            MOV opc,AX 
            RET
        menu ENDP
;Fijar el punto de entrada y detener el ensamblador.     
END start 

ENDS