;Ben bordi Taki eddine 202031044821 G3
;Maouche Mounir 202031044871 G4
;partie deux question 2 du projet archi 2
DATA SEGMENT
   compt dw 18
   Message1 DB "je suis passe par 1CH",10,13,"$"
DATA ENDS
 
pile SEGMENT stack
    DW 256 dup(?)
    TOS label word

pile ENDS
 
  CODE SEGMENT  
    
ASSUME cs:CODE,ds:DATA,ss:pile,es:DATA
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
    mov compt , 18
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


start:
     MOV AX, DATA                                  ;initialisation
     MOV DS, AX
     MOV AX, pile
     MOV SS, AX
     MOV SP, offset TOS
     
     call Derout
boucle: jmp boucle
     
     
 
CODE ends
 
end START