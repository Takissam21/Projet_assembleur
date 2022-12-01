;Ben bordi Taki eddine 202031044821 G3
;Maouche Mounir 202031044871 G4
;partie deux question 4-2 du projet archi 2
data SEGMENT
  messageinputnumber db 0ah,0dh,"Veillez tapez un nombre : $"
  number dw 0  
  messageinvalidcharacter db 0ah,0dh,"Erreur !$"
    msg db "deroutement fait...",10,10,13,"$"
    msg1 db "je suis dans la tache 1",10,13,"$"
    msg2 db "je suis dans la tache 2",10,13,"$"
    msg3 db "je suis dans la tache 3",10,13,"$"
   compt_1 dw 01h  
     compt_2 dw (?)  
     compt_3 dw (?)
     compt_4 dw 444h
data ends

mapile SEGMENT STACK
    dw 256 dup(?)
    tos label word
mapile ends

code SEGMENT
    assume cs:code , ds:data , ss:mapile
    
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
        
        numbercomplete: RET
        
    
    ;affichage de message deroutement fait
    afficher_msg proc near
      mov ax,seg msg
      mov ds,ax
      mov ax,offset msg
      mov dx,ax
      mov ah,9h
      INT 21h
      RET
   afficher_msg endp
    
    ;affichage de tache 1
   afficher_tache_1 proc near
      mov ax,seg msg1
      mov ds,ax
      mov ax,offset msg1
      mov dx,ax
      mov ah,9h
      INT 21h
      RET
   afficher_tache_1 endp

    ;affichage de tache 2
  afficher_tache_2 proc near
      mov ax,seg msg2
      mov ds,ax
      mov ax,offset msg2
      mov dx,ax
      mov ah,9h
      INT 21h
      RET
  afficher_tache_2 endp
   
    ;affichage de tache 3
  afficher_tache_3 proc near
      mov ax,seg msg3
      mov ds,ax
      mov ax,offset msg3
      mov dx,ax
      mov ah,9h
      INT 21h
      RET
  afficher_tache_3 endp
   

   
    ;installer le vecteur 1ch
   ; 25h/21h installer un nouveau vecteur  E/ AL : numero du vecteur  a installer
                                        ; DS:DX: les adresses cs et ip de la nouvelle routine d'int
  deroutement proc near
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
  deroutement endp
  
     ;j'ai initialiser le compture a 365 :18,2 requette*5=91 et on a 4 message donc 91*4 pour excute toutles programme
   new: 
         dec compt_1 
         jnz boucle1
         call afficher_tache_1
         mov compt_1,bx
        
   boucle1:dec compt_2
           jnz boucle2
           call afficher_tache_2
           mov compt_2,bx
       
       
   boucle2:dec compt_3 
            jnz fin
           call afficher_tache_3
           mov compt_3,bx
     fin:dec compt_4
        iret

 
 start:
    mov ax,data
    mov ds,ax
    mov ax,mapile
    mov ss,ax
    lea sp,tos
    Call Lire_entier
    mov cl,12h
    mul cl
    push ax
    mov cl , 3
    mul cl
    mov bx, ax
     pop ax
     mov compt_2 , ax
     add ax , ax
     mov compt_3 , ax
    
    call near ptr afficher_msg
    call near ptr deroutement
  
    check:  cmp compt_4, 0
        jne check
        mov ax, 4c00h
        int 21h  
  
code ends
end start