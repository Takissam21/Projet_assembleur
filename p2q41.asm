;Ben bordi Taki eddine 202031044821 G3
;Maouche Mounir 202031044871 G4
;partie deux question 4-1 du projet archi 2
data SEGMENT
    msg db "deroutement fait...",10,10,13,"$"
    msg1 db "je suis dans la tache 1",10,13,"$"
    msg2 db "je suis dans la tache 2",10,13,"$"
    msg3 db "je suis dans la tache 3",10,13,"$"
    compt db 6dh
data ends

mapile SEGMENT STACK
    dw 256 dup(?)
    tos label word
mapile ends

code SEGMENT
    assume cs:code , ds:data , ss:mapile
    
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
   new:  mov ax, seg compt
         mov ds, ax 
         dec compt 
         jnz boucle1
         call afficher_tache_1
         mov compt, 6dH
        
   boucle1:dec compt 
           jnz boucle2
           call afficher_tache_2
           mov compt, 6dH
       
       
   boucle2:dec compt 
            jnz fin
           call afficher_tache_3
           mov compt, 6dH
           fin:iret
 
 start:
    mov ax,data
    mov ds,ax
    mov ax,mapile
    mov ss,ax
    lea sp,tos
    call near ptr afficher_msg
    call near ptr deroutement
    boucle:jmp boucle
    
    mov ax,4c00h
    INT 21H
code ends
end start