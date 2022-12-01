;Ben bordi Taki eddine 202031044821 G3
;Maouche Mounir 202031044871 G4
;partie une du projet archi 2
DATA SEGMENT
    ;variables
    dix db 10
    vrai_taille dw 0
    taille dw 0
    temp db 0    
    tempx dw 0
    tempz dw 0
    nb_espace dw 0;variable de type word pour calculer le nombre de blancs
    ;messages a affiches
    msg db 0ah, 0dh,"la chaine apres l inversement est:$";afficher la chaine inversee
    msg2 db 0ah, 0dh,"la taille de la chaine inverse est (en hexadecimal):$";nouvelle taille inversee
    espace db 0ah, 0dh,"$";on l utilise pour compter le nombre de blanc dans la chaine
    chaine_taille db 5 dup('?'),"$"
    chaine db 250 dup('?'),"$";on met la chaine principale (donnee par l utilisateur) dans la memoire centrale (DS)
    chaine_inverse db 250 dup('?'),"$";on met la chaine inversee ( donnee par l utilisateur) dans la memoire centrale (DS)
    debut_taille db 0ah, 0dh,"veillez saisir la taille maximum du texte:$";saisir la taille de la chaine texte
    debut_chaine db 0ah, 0dh,"veillez saisir votre text: $"
    erreur_taille db 0ah, 0dh,"la taille saisie est incorrect car(taille>0 et taille<250) $";afficher ce message en cas ou la taille et inf a 1 ou sup a 250
    erreur2_taille db 0ah, 0dh,"3 essais sont passe.la taille choisi est la taille par defaut (250) $"
    erreur3_taille db 0ah, 0dh,"il faut entre un numero $";ce message affichera  si l'utilisateur donne des caracteres hors de chiffres
    erreur_chaine db 0ah, 0dh,"la chaine ne doit comporter que des caracteres alphabetique$";une alerte quand l'utilisateur a saisi des caracters hors de lettres alphabetiques        
DATA ENDS 

CODE SEGMENT 
    ASSUME DS:DATA, CS:CODE    
DEBUT:
      MOV AX,DATA        ;initialiser le data segment
      MOV DS,AX              
        CALL Taille_main ;appel a la procedure pour lire la taille de la chaine texte
        CALL Chaine_main ;appel a la procedure pour la lecture de la chaine
        MOV AH, 4CH      ;interruption fin du programme
        INT 21H
;-----------------------------------------------------------------------------------------------
  afficher proc          ;cette procedure est pour l affichage
        push ax
        mov ah, 09h
        int 21h
        pop ax
        ret
        afficher endp
;-----------------------------------------------------------------------------------------------          
Taille_main proc         ;procedure de pour afficher les exceptions de lecteure d'une taille     
        mov cx, 3        
saisir_taille:
        cmp cx, 0
        je default_taille
        call lire_taille
        cmp bx, 1
        jl re_saisir_taille
        cmp bx, 0FAh
        jg re_saisir_taille
        jmp fin_taille
re_saisir_taille:        ;pour saisir une autre fois la taille en cas d'erreur
        mov dx, offset erreur_taille
        call afficher
        loop saisir_taille           
default_taille:
        mov dx, offset erreur2_taille
        call afficher
        mov taille,0FAh   
fin_taille:
    MOV BX, taille
    mov dx, offset espace
    call afficher  
    ret
Taille_main endp
;-----------------------------------------------------------------------------------------------
lire_taille proc        ;procedure de pour lire la taille de la chaine
        push cx
        mov taille, 0
        MOV DX, OFFSET debut_taille
        call afficher
        mov dx, offset chaine_taille     
        MOV AH,0AH
        INT 21H
        xor bx, bx
        mov bl, chaine_taille+1
        mov chaine_taille[bx+2], '$'
        call taille_hexa
        mov bx, taille
        pop cx
        ret
lire_taille endp 
;-----------------------------------------------------------------------------------------------
taille_hexa proc      
        mov cx, bx
        mov bx, 1
        xor dx, dx
        xor ax, ax
        boucle:
        mov al, chaine_taille[bx+1] 
        cmp al, 30h
        jl er_taille_hexa
        cmp al, 39h
        jg er_taille_hexa     
        sub al, 30h
        mov ah, 00
        mov dx, ax     
        mov ax, taille
        mov temp, ah
        mul dix       
        add ax, dx       
        mov dx, ax
        mov al, temp
        mul dix
        add dh, al
        mov ax, dx        
        mov taille, ax
        inc bx       
        loop boucle
        jmp fin_taille_hexa        
er_taille_hexa:
        mov taille, 0
        mov dx, offset erreur3_taille
        call afficher        
fin_taille_hexa:        
        ret
        taille_hexa endp        
;------------------------------------------------------------------------------------------------  
Chaine_main proc 
saisir_chaine:
        mov nb_espace, 0
        mov dx, offset debut_chaine
        call afficher     
        mov bx, taille
        mov chaine, BL
        mov dx, offset chaine
        MOV AH, 0AH
        INT 21H
        XOR BX, BX
        MOV BL, chaine+1
        mov chaine[bx+2],'$'
        mov dx, offset espace
        call afficher
        mov dx, offset chaine+2
        call afficher
        mov cx, bx
        xor ax, ax
        xor bx, bx
test_chaine:
        inc bx        
        mov al, chaine[bx+1]
        cmp al, 20h
        je car_espace
        cmp ax, 41h
        jl car_invalid
        cmp ax, 7Ah
        jg car_invalid
        cmp ax, 61h
        jl re_test_chaine  
        jmp fin_test   
re_test_chaine:
        cmp ax, 5Ah
        jg car_invalid
        jmp fin_test
car_espace:
        inc nb_espace
fin_test:        
        loop test_chaine        
        jmp fin_chaine_main
car_invalid:
        mov dx, offset erreur_chaine                
        call afficher
        jmp saisir_chaine  
fin_chaine_main:
    CALL Inverser_chaine
    mov dx, offset espace
    call afficher
    mov dx, offset msg
    call afficher
    MOV DX, OFFSET chaine_inverse
    CALL afficher
    mov BX, vrai_taille
    mov dx, offset espace
    call afficher
    mov dx, offset msg2
    call afficher
    mov ax, vrai_taille
    call PRINT_HEXA    
    ret
    Chaine_main endp
;-----------------------------------------------------------------------------------------------
Inverser_chaine proc           ;procedure de pour inverser la chaine
    mov cx, nb_espace
    inc cx
    xor ax, ax
    xor bx, bx 
    mov chaine_inverse[bx],'*'
    inc vrai_taille
    inc bx
    mov chaine_inverse[bx],'*'
    inc vrai_taille
    mov tempx, bx 
    xor bx, bx 
nouveau_mot: 
    Call Proc_Empiler
Loop nouveau_mot    
    mov bx, tempx
    mov chaine_inverse[bx],'*'
    inc vrai_taille
    inc bx
    mov chaine_inverse[bx],'*'
    inc bx
    mov chaine_inverse[bx],'$'
    ret
    Inverser_chaine endp
;-----------------------------------------------------------------------------------------------
Proc_Empiler proc
    push cx
    xor cx, cx
    empiler:
    inc cx
    inc bx
    mov al, chaine[bx+1]
    push ax 
    cmp al, 20H
    je fin_empiler
    cmp al, '$'
    je fin_empiler 
    jmp empiler  
   fin_empiler:   
    mov tempz, bx
    mov bx, tempx  
    depiler:
    pop ax
    cmp al, 20h
    je fiin
    cmp al, '$'
    je fiin
    inc bx
    mov chaine_inverse[bx], al
    inc vrai_taille
fiin:               
    loop depiler 
    inc bx   
    mov chaine_inverse[bx], '#'
    inc vrai_taille
    inc bx   
    mov chaine_inverse[bx], ' '
    inc vrai_taille  
    mov tempx, bx   
    mov bx, tempz  
    pop cx        
    ret
    Proc_Empiler endp 
;-----------------------------------------------------------------------------------------------
PRINT_HEXA proc
        push    ax 
        push    cx
        push    dx  
        mov     cx,4            
LOOPA:
        push    cx     
        rol     ax,4             
        push    ax              		
        and     al,0fH          
        cmp     al,10            
        jb      CHIFFRE 
 
LETTRE: 
        add     al,'A'-10        
        jmp     AFFICHE 
 
CHIFFRE: 
        add     al,'0'           
 
AFFICHE: 
        mov     dl,al 
        mov     ah,2 
        int     21h               
        pop     ax               
        pop     cx              
        loop    LOOPA 
        pop     dx 
        pop     cx
        pop     ax 
        ret 
PRINT_HEXA  ENDP  
CODE ENDS
END DEBUT