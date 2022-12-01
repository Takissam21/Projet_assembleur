;Ben bordi Taki eddine 202031044821 G3
;Maouche Mounir 202031044871 G4
;partie deux question 3 du projet archi 2
DATA SEGMENT
    cycle db 18
    numberplace db 10
    number dw 0   
    messageinvalidcharacter db 0ah,0dh,"Erreur !$"
    messageinputnumber db 0ah,0dh,"Veillez tapez un nombre : $"
    
   compt dw 0
   Message1 DB 10,13,"je suis passe par 1CH","$"
DATA ENDS
 
pile SEGMENT stack
    DW 256 dup(?)
    TOS label word

pile ENDS
 
  CODE SEGMENT  
    
ASSUME cs:CODE,ds:DATA,ss:pile,es:DATA

Lire_entier proc
 loop_number_main:
        mov ah,09h  
        mov dx,offset messageinputnumber    ; Afficher le message
        int 21h     
    
        mov number,0    ; mettre la valeur initial en 0
        loop_read_number:

        mov ah,01h  ; Lecure d'un caractere
                
        int 21h  
    
        cmp al,30h  ; tester si le caractere < 0 
                    ; pour savoir si le caractere est entre 0 et 9
        jle invalidcharacter ; Alors Sauter vers le message d'erreur
 
        cmp al,39h  ; tester si le chiffre est >9
        jg invalidcharacter ; Alors Sauter vers le message d'erreur
    
    
        sub al,30h  ; Soustraire 30H au code pour obtenir la valeur numeric decimal
        mov ah,00                            
        
        mov number,ax   ; Enregistrer le nombre total
        JMP numbercomplete
    
        invalidcharacter:
        mov ah,09h  ; Affichier le message d'erreur
        mov dx,offset messageinvalidcharacter   
        int 21h     
    
        jmp loop_number_main           
        
        numbercomplete: 
        
ret
Lire_entier endp



affiche1CH proc 
    LEA DX,Message1                                 ;Affichage de Message
    MOV AH,09H
    INT 21H
    ret
affiche1CH endp


new :                                           ;traitement de l'interruption 1ch
    mov ax , seg compt
    dec compt                                      ;on utilise le compteur pour connaitre combien de fois l'int 1ch a ?t? appell?e
    jnz fin
    call affiche1CH
    mov compt , bx
fin:iret

;///////////////////////////////////////////////////////////////////////////////
Derout proc                                      ;Deroutement
    push ax
    push ds
    xor ax,ax 
    mov ds,ax
    mov si,1ch
    mov cl,2
    shl si,cl
    mov word ptr [si],offset new
    mov word ptr [si+2],seg new
    pop ds
    pop ax
    RET         
Derout endp

Init_Compt proc                                      
     xor bx,bx
     mov ax,number
     mul cycle
     mov compt,ax
     mov bx,ax
    ret         
Init_Compt endp



start:
     MOV AX, DATA                                  
     MOV DS, AX
     MOV AX, pile
     MOV SS, AX
     MOV SP, offset TOS
     
     Call Lire_entier
     call Init_Compt
     call Derout
boucle: jmp boucle
     
     
 
CODE ends
 
end START