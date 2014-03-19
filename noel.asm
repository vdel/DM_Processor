	nop		/	ldi0 33		;r11: caractère à afficher
	mov r11 r0	/	ldi0 93		;r12: 93=126-33: compteur pour afficher les 93 caractères
	mov r12	r0	/	ldi0 0xE0	
	mov r4 r0	/	ldi0 0		;on affiche en rouge
	mov r2 r0	/	mov r3 r0	;coordonnées initiales
affich:
	nez p7 r12	/	nop
	mov r1 r11 	/	sra r15        
	jrf putc	/	inc r11 r11
	?p7 jrb affich	/	dec r12 r12	;on boucle pour afficher les caratères 33 à 126
  	inc r3 r3	/	ldi0 0xF8
	inc r3 r3	/	mov r4 r0
	inc r3 r3	/	ldi0 0
	mov r2 r0	/	nop		;on saute deux lignes
	sra r15		/	ldi0 0x4a
	jrf putc	/	mov r1 r0	;J
	sra r15		/	ldi0 0x6f
	jrf putc	/	mov r1 r0	;o
	sra r15		/	ldi0 0x79
	jrf putc	/	mov r1 r0	;y
	sra r15		/	ldi0 0x65
	jrf putc	/	mov r1 r0	;e
	sra r15		/	ldi0 0x75
	jrf putc	/	mov r1 r0	;u
	sra r15		/	ldi0 0x78
	jrf putc	/	mov r1 r0	;x
	sra r15		/	ldi0 0x20
	jrf putc	/	mov r1 r0	;espace
	sra r15		/	ldi0 0x6e
	jrf putc	/	mov r1 r0	;n
	sra r15		/	ldi0 0x6f
	jrf putc	/	mov r1 r0	;o
	sra r15		/	ldi0 0x65
	jrf putc	/	mov r1 r0	;e
	sra r15		/	ldi0 0x6c
	jrf putc	/	mov r1 r0	;l
	sra r15		/	ldi0 0x20
	jrf putc	/	mov r1 r0	;espace
	sra r15		/	ldi0 0x65
	jrf putc	/	mov r1 r0	;e
	sra r15		/	ldi0 0x74
	jrf putc	/	mov r1 r0	;t
	sra r15		/	ldi0 0x20
	jrf putc	/	mov r1 r0	;espace
	sra r15		/	ldi0 0x62
	jrf putc	/	mov r1 r0	;b
	sra r15		/	ldi0 0x6f
	jrf putc	/	mov r1 r0	;o
	sra r15		/	ldi0 0x6e
	jrf putc	/	mov r1 r0	;n
	sra r15		/	ldi0 0x6e
	jrf putc	/	mov r1 r0	;n
	sra r15		/	ldi0 0x65
	jrf putc	/	mov r1 r0	;e
	sra r15		/	ldi0 0x73
	jrf putc	/	mov r1 r0	;s
	sra r15		/	ldi0 0x20
	jrf putc	/	mov r1 r0	;espace
	sra r15		/	ldi0 0x76
	jrf putc	/	mov r1 r0	;v
	sra r15		/	ldi0 0x61
	jrf putc	/	mov r1 r0	;a
	sra r15		/	ldi0 0x63
	jrf putc	/	mov r1 r0	;c
	sra r15		/	ldi0 0x61
	jrf putc	/	mov r1 r0	;a
	sra r15		/	ldi0 0x6e
	jrf putc	/	mov r1 r0	;n
	sra r15		/	ldi0 0x63
	jrf putc	/	mov r1 r0	;c
	sra r15		/	ldi0 0x65
	jrf putc	/	mov r1 r0	;e
	sra r15		/	ldi0 0x73
	jrf putc	/	mov r1 r0	;s
	sra r15		/	ldi0 0x21
	jrf putc	/	mov r1 r0	;!

	;; Affichage des flocons
	;; r10: nombre "aléatoire"
	;; r11: le nombre de flocons
	;; r13: vent de -2 à 2
	ldl32 2687845668
	mov r10	r0	/	ldi0 60		;on initialise le générateur de nombre aléatoire
	mov r11 r0	/	ldi0 0		;on a r11 flocons
	mov r13 r0	/	nop
						;séquence d'initialisation	
	nop		/	mov r9 r11
	dec r9 r9	/	nop		;on charge le nombre de flocons dans r9
	ldl32 flocons
	mov r4 r0	/	nop		;on charge l'adresse ou sont stockées les données concernant les flocons dans r4
init_seq:
	nez p6 r9	/	sra r15		
	jrf init_flocon	/	nop		;on initialise les coordonnées et on stocke la couleur a rétablir
	sra r15		/	nop
	jrf find_coord	/	nop		;on calcule les coordonnées
	nop		/	ldi0 0xFF	
	mov r1 r0	/	mov r8 r4	;on stocke la couleur dans r1: blanc (on sauve r4 (adresse des flocons) car plot le modifie)
	nop		/	sra r15
	jrf plot	/	dec r9 r9	;on affiche le flocon
	?p6 jrb init_seq /	inc r4 r8	;on recommence s'il reste des flocons
boucle:
	nop		/	mov r9 r11	;ici:on va faire bouger les flocons
	dec r9 r9	/	nop		;r9: nombre de flocons
	ldl32 flocons
	mov r4 r0	/	nop		;r4: adresse des flocons
move_seq:
	nez p6 r9	/	sra r15		;on trouve les coordonnées du flocon
	jrf find_coord	/	dec r9 r9	;on diminue le compteur
	mov r6 r2	/	mov r7 r3	;on sauve x et y
	sra r15		/	mov r8 r1	;et la couleur
	jrf find_color	/	nop		;on cherche la couleur à l'écran en (x,y)
	mov r1 r8	/	ldi0 0xFF	
	sub r3 r0	/	nop		;si c'est pas du blanc: collision avec un autre flocon
	eqz p1 r3	/	mov r2 r6	;il a déjà restauré le pixel, on n'a pas à le faire
	sra r15		/	mov r3 r7
	?p1 jrf plot	/	mov r8 r4	;on affiche
	mov r2 r6	/	mov r3 r7	;on restore x et y en r2 et r3
	sra r15		/	mov r4 r8
	jrf move_flocon	/	nop		;on bouge le flocon
	nop		/	ldi0 0xFF	;on a r2: nouveau x et r3: nouveau y
	mov r1 r0	/	sra r15
	jrf plot	/	inc r8 r4	;r4: on passe à l'adresse suivante
	?p6 jrb move_seq /	mov r4 r8	;on restore l'adresse en r4

	nop		/	ldi0 3
	nop		/	and r0 r10
	eqz p7 r0	/	mov r5 r0	;x<-x+vent et on masque r10 par 0x3
	?p7 jrf	5	/	ldi0 2		;si r0 vaut 0, on ne modifie pas x
	sub r5 r0	/	ldi0 29		;sinon
	add r13 r5	/	nop		;on fait x<x+r0-2
	lsl r13 r0	/	nop
	jrb boucle	/	asr r13 r0	;on recommence
	jrb boucle	/	nop

;;--------------------------------------------------------------------------------------------;;
;;											      ;;
;;  next_number										      ;;
;;  											      ;;
;;  Prend en argument le nombre aléatoire en r10 et en calcule un nouveau dans r10	      ;;
;;											      ;;
;;  Modifie r0 r5 r6									      ;;
;;--------------------------------------------------------------------------------------------;;
next_number: ;;modifie r0 r5 r6
	mov r5 r10	/	ldi0 13
	lsl r5 r0	/	ldi0 4		;on décale une copie de r10 à gauche
	add r10 r5	/	nop		;on ajoute cette copie à r10
	not r10 r10	/	mov r6 r10	;on inverse r10
	lsr r6 r0	/	nop		;on décale une copie du r10 non inversé à droite
	ja r15		/	xor r10 r6	;un petit xor pour finir

;;--------------------------------------------------------------------------------------------;;
;;											      ;;
;;  find_coord										      ;;
;;  											      ;;
;;  Prend en argument l'adresse du flocon en r4						      ;;
;;  Renvoit: la couleur sous le flocon en r1						      ;;
;;	     l'abscisse du flocon en r2							      ;;
;;           l'ordonnée du flocon en r3							      ;;
;;											      ;;
;;  Modifie r0 r1 r2 r3									      ;;
;;--------------------------------------------------------------------------------------------;;
find_coord:
	ld r2 r4	/	ldi0 0xFF	;on charge la donnée du flocon en r2 
	mov r1 r0	/	ldi0 8		;(voir format au label flocons)
	mov r3 r1	/	nop		;on prépare le masque FF en r1 et r3
	lsr r2 r0	/	and r1 r2	;on masque et on décale
	lsr r2 r0	/	and r3 r2	;on masque et on décale
	ja r15		/	nop		;on récupère x en r2

;;--------------------------------------------------------------------------------------------;;
;;											      ;;
;;  verif_coord										      ;;
;;  											      ;;
;;  Prend en argument l'adresse du flocon en r4						      ;;
;;  On considère l'écran comme un tore:							      ;;
;;  si le flocon sort de l'écran, en fait il passe de l'autre coté			      ;;
;;											      ;;
;;  Modifie r0 r1 r2 r3 r5 r6 r7 r8							      ;;
;;--------------------------------------------------------------------------------------------;;
verif_coord: 	
	mov r5 r15	/	sra r15
	jrb find_coord	/	nop		;;on calcule les coordonnées et la couleur
	mov r15 r5	/	nop
						;!! début vérification des coordonnées !!
	ldl16 320
	lsz p1 r2 	/	nop		;si x est strictement négatif
	?p1 add r2 r0	/	mov r5 r0	;x<-x+320 et on sauve 320 dans r5
	ldl16 256
	lsz p1 r3	/	nop		;si y est strictement y négatif
	?p1 add r3 r0	/	mov r6 r0	;y<-y+256 et on sauve 256 dans r6
	mov r7 r2	/	mov r8 r3	;on copie x et y dans r7 et r8
	sub r7 r5	/	sub r8 r6	;r7<-x-320 et r8<-y-256
	gez p1 r7	/	gez p2 r8	;si r7 ou r8 >= 0 alors ils sont trop grand
	?p1 sub r2 r5	/	?p2 sub r3 r6	;(on les fait passer de l'autre coté de l'écran)
						;!! fin vérification des coordonnées !!
	nop		/	ldi0 8		;on reconstruit le mot du flocon dans r4
	lsl r2 r0	/	lsl r3 r0
	lsl r2 r0	/	add r1 r3
	nop		/	add r1 r2
	str r1 r4	/	ja r15		;et on le stocke

;;--------------------------------------------------------------------------------------------;;
;;											      ;;
;;  find_color										      ;;
;;  											      ;;
;;  Prend en argument l'adresse du flocon en r4						      ;;
;;		      x en r2								      ;;
;;		      y en r3								      ;;
;;  Renvoit: la couleur sous le flocon en r3						      ;;
;;											      ;;
;;  Modifie r0 r1 r2 r3									      ;;
;;--------------------------------------------------------------------------------------------;;
find_color: 
	mov r1 r2 	/ 	ldi0 2		;on copie x dans r1
	lsr r2 r0 	/ 	ldi0 80		;on divise x par 4: r2 contient l'abscisse en mots de 32 bits
	nez p1 r3 	/ 	dec r3 r3	;Tant que r3=y ne vaut pas 0...
	add r2 r0 	/ 	?p1 jrb 0x1	;...on ajoute 80=360/4 à r2 et on décrémente r3
	sub r2 r0 	/ 	ldi0 3		;on a aouté une fois de trop: on retire 80 à r2
	and r1 r0 	/	nop 		;r1 contient alors x mod 4
	lsl r1 r0	/	ldi0 0xff	;r1<-8*r1, r0 un masque sur 1 octet
	ld r3 r2	/	lsl r0 r1 	;on décale le masque et on charge le mot à modifier dans r3
	nop 		/ 	and r3 r0	;on masque
	ja r15 		/ 	lsr r3 r1	;on récupère la couleur dans r3

;;--------------------------------------------------------------------------------------------;;
;;											      ;;
;;  init_flocon										      ;;
;;  											      ;;
;;  Prend en argument l'adresse du flocon en r4						      ;;
;;  Initialise les coordonnées d'un flocon et calcul la couleur sous le flocon		      ;;
;;											      ;;
;;  Modifie r0 r1 r2 r3 r5 r6 r7 r8 r14							      ;;
;;--------------------------------------------------------------------------------------------;;
init_flocon:
	;on tire des coordonnées au pif
	ldl16 511				;masque pour le nombre aléatoire (=r10)
	mov r1 r0	/	ldi0 8
	mov r2 r10	/	lsr r10 r0	;on prend des valeurs au pif (les 10 premiers bits de r10)
	and r2 r1	/	mov r3 r10	;dans r2=x on a une valeur entre 0 et 511
	and r3 r1	/	ldi0 1		;de même dans r3
	lsr r3 r0	/	ldi0 8		;donc on décale de 1: valeur entre 0 et 255
	lsl r2 r0	/	lsl r3 r0	;on décale tout ca
	lsl r2 r0	/	mov r14 r15	;pour fabriquer la donnée flocon
	sra r15		/	add r2 r3	;
	str r2 r4	/	jrb verif_coord	;on stocke cette donnée et on vérifie que x<320
		
	;on cherche les vraies coordonnées du flocon
	sra r15		/	nop		
	jrb find_coord	/	nop		;on récupère les vraies coordonnées du flocon
	mov r5 r2	/	mov r6 r3	;et on copie x et y: r5=x et r6=y

	;maintenant on veut la couleur sous le flocon
	sra r15		/	nop
	jrb find_color  /	nop		;on récupère dans r3 la couleur sous le flocon
	;on reconstruit le flocon
	nop		/	ldi0 8		;on reconstruit la donnée flocon
	lsl r5 r0	/	lsl r6 r0	;on a toujours r5=x et r6=y
	lsl r5 r0	/	add r3 r6
	nop		/	add r3 r5
	str r3 r4	/	sra r15		;on stocke
	jrb next_number	/	nop		;on change le nombre aléatoire
	ja r14		/	nop		;on rend la main

;;--------------------------------------------------------------------------------------------;;
;;											      ;;
;;  move_flocon										      ;;
;;  											      ;;
;;  Prend en argument l'adresse du flocon en r4,x dans r2 et y dans r3			      ;;
;;  Fait bouger le flocon et renvoie en r2 le nouveau x, en r3 le nouveau y		      ;;
;;											      ;;
;;  Modifie r0 r1 r2 r3 r5 r6 r7 r8 r14 p7						      ;;
;;--------------------------------------------------------------------------------------------;;	
move_flocon:
	mov r14 r15	/	ldi0 255	;on va vérifier que le flocon est pas arrivé en bas
	sub r0 r3	/	add r2 r13	;x<-x+vent
	nez p7 r0	/	ldi0 3		;sur la voie 0, on commence à faire le "sinon" (cf ci-dessous)
	?p7 jrf	mov_floc_else / and r0 r10	;en r0: un nombre au pif entre 0 et 3
;si flocon est en bas
	mov r2 r10	/	sub r3 r3	;on prend le nombre aléatoire et on annule r3
	ldl16 0x1FF				
	jrf mov_floc_endif /	and r2 r0
mov_floc_else:	 				;flocon pas en bas
	eqz p7 r0	/	mov r5 r0	;et on masque r10 par 0x3
	?p7 jrf	2	/	ldi0 2		;si r0 vaut 0, on ne modifie pas x
	sub r5 r0	/	nop		;sinon
	add r2 r5	/	inc r3 r3	;on fait x<x+r0-2 et y<-y+1
mov_floc_endif:
	ldl16 320				
	lsz p7 r2	/	mov r5 r2	;on vérifie que x est positif
	?p7 add r2 r0	/	sub r5 r0	;si non: on ajoute 320
	gez p7 r5	/	nop		;on vérifie que x n'est pas plus grand que 320
	?p7 sub r2 r0	/	nop		;s'il l'est: on soustrait 320
	mov r5 r2	/	mov r6 r3
	
	;maintenant on veut la couleur sous le flocon
	sra r15		/	nop
	jrb find_color  /	nop

	;on reconstruit le flocon, on a toujours r5=x et r6=y
	mov r1 r3	/	ldi0 8		;on stocke la couleur dans r1
	mov r2 r5	/	mov r3 r6	;on place r2=x et r3=y
	lsl r5 r0	/	lsl r6 r0	;on décale x et y
	lsl r5 r0	/	add r1 r6	;on les ajoute à la couleur	
	add r1 r5	/	sra r15		;
	str r1 r4	/	jrb next_number	;on stocke et on change le nombre aléatoire
	ja r14		/	nop		;on rend la main	

;;--------------------------------------------------------------------------------------------;;
;;											      ;;
;;  safeplot										      ;;
;;  											      ;;
;;  Arguments de safeplot:								      ;;
;;    r1: couleur									      ;;
;;    r2: x										      ;;
;;    r3: y										      ;;
;;    r15: adresse de retour								      ;;
;;  safeplot est une version sécurisée de plot :					      ;;
;;    - n'a d'effet que si 0 <= x <= 319 et 0 <= y <= 255				      ;;
;;    - choisit 0xff comme couleur si couleur > 0xff					      ;;
;;    - renvoie dans r1 la couleur qui était à l'écran avant le plot			      ;;
;;											      ;;
;;  Modifie r0 r1 r2 r3 r4 r5 								      ;;
;;--------------------------------------------------------------------------------------------;;	
safeplot:
                                                ;verification des coordonnées

        lsz p1 r2       /       nop             ;si x est strictement négatif
        ?p1 ja r15      /       nop             ;alors on quitte

        lsz p1 r3       /       nop             ;si y est strictement négatif
        ?p1 ja r15      /       nop             ;alors on quitte

        ldl16 319
	sub r0 r2	/	nop             ;r0 <- 319 - x
        lsz p1 r0       /       nop             ;si r0 < 0 (c'est à dire si x > 319)
        ?p1 ja r15      /       nop             ;alors on quitte

        ldl16 255
	sub r0 r3	/	nop             ;r0 <- 255 - y
        lsz p1 r0       /       nop             ;si r0 < 0 (c'est à dire si y > 255)
        ?p1 ja r15      /       nop             ;alors on quitte
        
        ldl16 0xff
        and r1 r0	/	nop		;on borne la couleur par 0xff 

						;dans la suite, on recopie plot en le modifiant un peu pour
                                                ;stocker la couleur d'origine dans r1

	mov r4 r2 	/ 	ldi0 2		;on copie x dans r4
	lsr r2 r0 	/ 	ldi0 80		;on divise x par 4: r2 contient l'abscisse en mots de 32 bits
	nez p1 r3 	/ 	dec r3 r3	;Tant que r3=y ne vaut pas 0...
	add r2 r0 	/ 	?p1 jrb 0x1	;...on ajoute 80=360/4 à r2 et on décrémente r3
	sub r2 r0 	/ 	ldi0 3		;on a ajouté une fois de trop: on retire 80 à r2
	and r4 r0 	/ 	nop		;r4 contient alors x mod 4
	lsl r4 r0	/	ldi0 0xff	;r4<-8*r4, r0 un masque sur 1 octet
	lsl r0 r4 	/ 	lsl r1 r4	;on décale le masque et la couleur pour les ajuster au niveau du bon octet
	ld r3 r2	/ 	nop             ;on charge le mot à modifier dans r3

	mov r5 r3	/	nop		;r5 <- les couleurs des 4 pixels originaux
	and r5 r0	/	nop		;r5 <- la couleur du pixel d'origine
	lsr r5 r4	/	nop		;r5 <- la couleur voulue (décalée a droite)

	not r0 r0	/	nop		;on inverse le masque
	nop 		/ 	and r3 r0	;on masque
	nop 		/ 	add r3 r1	;on ajoute
	str r3 r2 	/ 	nop		;on sauve

	mov r1 r5	/	nop		;r1 <- couleur d'origine

	ja r15		/	nop		;on quitte

;;--------------------------------------------------------------------------------------------;;
;;											      ;;
;;  plot										      ;;
;;  											      ;;
;;  Arguments de plot:									      ;;
;;    r1: couleur									      ;;
;;    r2: x										      ;;
;;    r3: y										      ;;
;;    r15: adresse de retour								      ;;
;;  plot affiche un pixel de couleur r1 en x,y						      ;;
;;											      ;;
;;  Modifie r0 r1 r2 r3 r4								      ;;
;;--------------------------------------------------------------------------------------------;;	
plot:		
	mov r4 r2 	/ 	ldi0 2		;on copie x dans r4
	lsr r2 r0 	/ 	ldi0 80		;on divise x par 4: r2 contient l'abscisse en mots de 32 bits
	nez p1 r3 	/ 	dec r3 r3	;Tant que r3=y ne vaut pas 0...
	add r2 r0 	/ 	?p1 jrb 0x1	;...on ajoute 80=360/4 à r2 et on décrémente r3
	sub r2 r0 	/ 	ldi0 3		;on a ajouté une fois de trop: on retire 80 à r2
	and r4 r0 	/ 	nop		;r4 contient alors x mod 4
	lsl r4 r0	/	ldi0 0xff	;r4<-8*r4, r0 un masque sur 1 octet
	lsl r0 r4 	/ 	lsl r1 r4	;on décale le masque et la couleur pour les ajuster au niveau du bon octet
	ld r3 r2	/ 	not r0 r0	;on charge le mot à modifier dans r3 (et on inverse le masque)
	nop 		/ 	and r3 r0	;on masque
	nop 		/ 	add r3 r1	;on ajoute
	str r3 r2 	/ 	ja r15		;on sauve et on quitte

;;--------------------------------------------------------------------------------------------;;
;;											      ;;
;;  putc										      ;;
;;  											      ;;
;;  Arguments de putc:									      ;;
;;    r1: caractère à afficher								      ;;
;;    r2: colonne où afficher								      ;;
;;    r3: ligne où afficher								      ;;
;;    r4: couleur									      ;;
;;    r15: adresse de retour								      ;;
;;  putc affiche un caractère et met à jour le curseur, vérifie les coordonnées et la couleur ;;
;;											      ;;
;;  Modifie r0 r1 r2 r3 r5 r6 r7 r8 r13 r14 r15 p1					      ;;
;;--------------------------------------------------------------------------------------------;;
putc:		
	;début vérification des coordonnées
	lsz p1 r2 	/	ldi0 39		;on vérifie que r2 est positif
	?p1 sub r2 r2	/	mov r5 r0	;sinon r2 recoit 0
	lsz p1 r3	/	ldi0 31		;on vérifie que r3 est positif
	?p1 sub r3 r3	/	mov r6 r0	;sinon r3 recoit 0
	mov r7 r2	/	mov r8 r3	;on copie x et y dans r7 et r8
	sub r7 r5	/	sub r8 r6	;r7<-x-39 et r8<-y-31
	gsz p1 r7	/	gsz p2 r8	;si r7 ou r8 > 0 alors ils sont trop grand
	?p1 mov r2 r5	/	?p2 mov r3 r6	;on les ramène donc à la bonne valeur
	;fin vérification des coordonnées
	inc r7 r2	/	mov r8 r3	;on stocke la nouvelle colonne dans r7, la ligne courante dans r8
	mov r13 r15	/	ldi0 0xFF	;on sauve l'adresse de retour
	sra r15		/	and r4 r0	;on masque la couleur (au cas ou...)
	jrf putcxy	/	nop		
	mov r5 r7	/	ldi0 40     	;on vérifie que on sort pas de l'écran
	sub r5 r0	/	ldi0 31     	;r5 <- (x+1) - 40
	gez p1 r5 	/	mov r6 r8
	?p1 jrf	3	/	sub r6 r0	;si (x+1) < 40 alors:
	mov r2 r7	/	mov r3 r8	;  x <- x+1 et y<-y
	ja r13		/	nop		;  fin de putc
	lsz p1 r6       /	ldi0 0		;sinon
	?p1 inc r8 r8	/	mov r2 r0	;  x<-0 et si y<31 alors y<-y+1
	ja r13		/	mov r3 r8

;;--------------------------------------------------------------------------------------------;;
;;											      ;;
;;  putcxy										      ;;
;;  											      ;;
;;  Arguments de putcxy:								      ;;
;;    r1: caractère à afficher								      ;;
;;    r2: colonne où afficher								      ;;
;;    r3: ligne où afficher								      ;;
;;    r4: couleur									      ;;
;;    r15: adresse de retour								      ;;
;;  putcxy affiche un caractère. putcxy ne vérifie ni les coordonnées, ni la couleur 	      ;;
;;  106 instructions pour afficher un caractère en 0,0					      ;;
;;											      ;;
;;  Modifie r0 r1 r2 r3 r5 r6 r14 p1							      ;;
;;--------------------------------------------------------------------------------------------;;
putcxy:		
	eqz p1 r3	/	ldi0 1      	;y=r3=0?
	lsl r1 r0	/	lsl r2 r0   	;on multiplie r2 par 2 pour avoir la bonne colonne
	 					;on multiplie r1 par deux car chaque carac est codé sur 2 octets.
	?p1 jrf ptcxy_endwhile / dec r3 r3	;si y=0, on passe à la suite, sinon il faut ajuster r2
	ldl16 640 				;décalage mémoire à effectuer pour passer à la ligne suivante 
ptcxy_while:					;tant que r3>0,
	nez p1 r3	/	dec r3 r3	;on ajoute 640 à r2 pour arriver à la bonne ligne
	?p1 jrb ptcxy_while /	add r2 r0
ptcxy_endwhile:			
	ldl32 putcxy_codes
	add r1 r0	/	mov r6 r4   	;dans r1, adresse mémoire du premier mot du caractère
	ld r5 r1	/	ldi0 8	    	;premier mot dans r5			
	inc r1 r1	/	lsl r6 r0	;dans r1, adresse mémoire du second mot du caractère
	add r4 r6	/	ldi0 16
	mov r6 r4	/	lsl r4 r0	;on bidouille pour recopier r4 4 fois
	ldl32 ptcxy_masks			;on charge l'adresse des masques
	mov r3 r0	/	add r4 r6
						; On récapitule:
						; r1: adresse mémoire de la demi-matrice inférieure
						; r2: adresse vidéo où on écrit
						; r3: adresse des masques
						; r4: couleur répétée 
						; r5: demi-matrice supérieur
	
	sra r14		/	ldi0 0xF
	jrf ptcxy_line	/	and r0 r5	;ligne 1
	sra r14		/	ldi0 0xF
	jrf ptcxy_line	/	and r0 r5	;ligne 2
	sra r14		/	ldi0 0xF
	jrf ptcxy_line	/	and r0 r5	;ligne 3
	sra r14		/	ldi0 0xF
	jrf ptcxy_lastline /	and r0 r5	;ligne 4, fin du premier mot
	sra r14		/	ldi0 0xF
	jrf ptcxy_line	/	and r0 r5	;ligne 5
	sra r14		/	ldi0 0xF
	jrf ptcxy_line	/	and r0 r5	;ligne 6
	sra r14		/	ldi0 0xF
	jrf ptcxy_line	/	and r0 r5	;ligne 7
	sra r14		/	ldi0 0xF
	jrf ptcxy_lastline /	and r0 r5	;ligne 8, fin du second mot
	ja r15		/	nop

ptcxy_line: ;affiche la ligne 1, 2, 3, 5, 6 ou 7
	add r0 r3	/	nop		; r0 <- r3(=adresse des masques) + (r5 & 0xF) (=type de demi-ligne)
	ld r6 r0	/	ldi0 4          ; on charge le masque
	and r6 r4	/	lsr r5 r0	; on masque la couleur et on décale la matrice
	str r6 r2	/	ldi0 0xF	; on met à jour la partie gauche de la ligne
	and r0 r5	/	inc r2 r2 	; on passe à la demi-ligne de gauche
	add r0 r3	/	nop		; r0 <- r3(=adresse des masques) + (r5 & 0xF) (=type de demi-ligne)
	ld r6 r0	/	ldi0 4 		; on charge le masque
	and r6 r4	/	lsr r5 r0	; on masque la couleur et on décale la matrice
	str r6 r2	/	ldi0 79		; on met à jour la partie gauche de la ligne
	ja r14		/	add r2 r0	; on passe à la ligne suivante en revenant à la demi-ligne de gauche

ptcxy_lastline: ;affiche les lignes 4 ou 8      idem que ptcxy_line sauf:
	add r0 r3	/	nop		
	ld r6 r0	/	ldi0 4
	and r6 r4	/	lsr r5 r0
	str r6 r2	/	add r5 r3	;pas besoin de masquer r5: on l'ajoute directement à r3	 		
	ld r6 r5	/	inc r2 r2
	ld r5 r1	/	and r6 r4	;pas besoin de décaler r5:on charge la matrice inférieur depuis r1
	str r6 r2	/	ldi0 79
	ja r14		/	add r2 r0

ptcxy_masks: 					;masques pour la couleur
	_0x00000000
	_0xFF000000
	_0x00FF0000
	_0xFFFF0000
	_0x0000FF00
	_0xFF00FF00
	_0x00FFFF00
	_0xFFFFFF00
	_0x000000FF
	_0xFF0000FF
	_0x00FF00FF
	_0xFFFF00FF
	_0x0000FFFF
	_0xFF00FFFF
	_0x00FFFFFF
	_0xFFFFFFFF
	
putcxy_codes:
	;un caratère est codé sur 64 bits: 1er mots, les 4 lignes du haut, 2nd mot, les 4 lignes du bas
	;Une ligne est codée sur un octet,dans un mot, les octets de poids plus faible sont le plus en haut.
	;L'écriture binaire d'un octect repésente la ligne: 0 pixel éteind, 1 pixel allumé.
	_0x00000000
	_0x00000000
	_0x185a18e7
	_0xe71899db
	_0xffbdffe7
	_0xe7ff7e3c
	_0xefefefc6
	_0x000183c7
	_0xefc78301
	_0x000183c7
	_0xef83c783
	_0xc783c7ef
	_0xc7830101
	_0xc783c7ef
	_0xc3810000
	_0x000081c3
	_0x3c7effff
	_0xffff7e3c
	_0x2466c300
	_0x00c36624
	_0xdb993cff
	_0xff3c99db
	_0xd7f070f0
	_0x87cccccc
	_0x666666c3
	_0x81e781c3
	_0x03f333f3
	_0x0e0f0703
	_0x36f736f7
	_0x0c6e7636
	_0x7ec3a599
	_0x99a5c37e
	_0xef8f0e08
	_0x00080e8f
	_0xefe3e020
	_0x0020e0e3
	_0x81e7c381
	_0x81c3e781
	_0x66666666
	_0x00660066
	_0xb7bdbdf7
	_0x00b1b1b1
	_0xc68336e3
	_0x87cc83c6
	_0x00000000
	_0x00e7e7e7
	_0x81e7c381
	_0xff81c3e7
	_0x81e7c381
	_0x00818181
	_0x81818181
	_0x0081c3e7
	_0xefc08100
	_0x000081c0
	_0xef060300
	_0x00000306
	_0x0c0c0000
	_0x0000ef0c
	_0xff664200
	_0x00004266
	_0xe7c38100
	_0x0000ffff
	_0xe7ffff00
	_0x000081c3
	_0x00000000
	_0x00000000
	_0x03878703
	_0x00030003
	_0x00c6c6c6
	_0x00000000
	_0xc6efc6c6
	_0x00c6c6ef
	_0x870cc703
	_0x00038fc0
	_0x81cc6c00
	_0x006c6603
	_0x6783c683
	_0x0067cccd
	_0x000c0606
	_0x00000000
	_0x06060381
	_0x00810306
	_0x81810306
	_0x00060381
	_0xffc36600
	_0x000066c3
	_0xcf030300
	_0x00000303
	_0x00000000
	_0x06030300
	_0xcf000000
	_0x00000000
	_0x00000000
	_0x00030300
	_0x0381c060
	_0x00080c06
	_0xedec6cc7
	_0x00c76e6f
	_0x03030703
	_0x00cf0303
	_0x83c0cc87
	_0x00cfcc06
	_0x83c0cc87
	_0x0087ccc0
	_0xccc6c3c1
	_0x00e1c0ef
	_0xc08f0ccf
	_0x0087ccc0
	_0x8f0c0683
	_0x0087cccc
	_0x81c0cccf
	_0x00030303
	_0x87cccc87
	_0x0087cccc
	_0xc7cccc87
	_0x000781c0
	_0x00030300
	_0x00030300
	_0x00030300
	_0x06030300
	_0x0c060381
	_0x00810306
	_0x00cf0000
	_0x0000cf00
	_0xc0810306
	_0x00060381
	_0x81c0cc87
	_0x00030003
	_0xeded6cc7
	_0x00870ced
	_0xcccc8703
	_0x00cccccf
	_0xc76666cf
	_0x00cf6666
	_0x0c0c66c3
	_0x00c3660c
	_0x6666c68f
	_0x008fc666
	_0x878626ef
	_0x00ef2686
	_0x878626ef
	_0x000f0686
	_0x0c0c66c3
	_0x00e366ec
	_0xcfcccccc
	_0x00cccccc
	_0x03030387
	_0x00870303
	_0xc0c0c0e1
	_0x0087cccc
	_0x87c6666e
	_0x006e66c6
	_0x0606060f
	_0x00ef6626
	_0xefefee6c
	_0x006c6c6d
	_0xed6f6e6c
	_0x006c6cec
	_0x6c6cc683
	_0x0083c66c
	_0xc76666cf
	_0x000f0606
	_0xcccccc87
	_0x00c187cd
	_0xc76666cf
	_0x006e66c6
	_0x070ecc87
	_0x0087ccc1
	_0x03034bcf
	_0x00870303
	_0xcccccccc
	_0x00cfcccc
	_0xcccccccc
	_0x000387cc
	_0x6d6c6c6c
	_0x006ceeef
	_0x83c6446c
	_0x006cc683
	_0x87cccccc
	_0x00870303
	_0x81c86cef
	_0x00ef6623
	_0x06060687
	_0x00870606
	_0x8103060c
	_0x002060c0
	_0x81818187
	_0x00878181
	_0x6cc68301
	_0x00000000
	_0x00000000
	_0xff000000
	_0x00810303
	_0x00000000
	_0xc0870000
	_0x00c7ccc7
	_0xc7060606
	_0x00c76666
	_0xcc870000
	_0x0087cc0c
	_0xc7c0c0c0
	_0x00c7cccc
	_0xcc870000
	_0x00870ccf
	_0x0f06c683
	_0x000f0606
	_0xccc70000
	_0x8fc0c7cc
	_0x66c70606
	_0x00666666
	_0x03070003
	_0x00870303
	_0xc0c000c0
	_0x83c6c0c0
	_0xc6660606
	_0x0066c687
	_0x03030307
	_0x00870303
	_0xefcc0000
	_0x006c6def
	_0xcc8f0000
	_0x00cccccc
	_0xcc870000
	_0x0087cccc
	_0x66c70000
	_0x0606c766
	_0xccc70000
	_0xc0c0c7cc
	_0x67cd0000
	_0x000f0666
	_0x0cc70000
	_0x008fc087
	_0x03c70301
	_0x00814303
	_0xcccc0000
	_0x00c7cccc
	_0xcccc0000
	_0x000387cc
	_0x6d6c0000
	_0x00c6efef
	_0xc66c0000
	_0x006cc683
	_0xcccc0000
	_0x8fc0c7cc
	_0x89cf0000
	_0x00cf4603
	_0x0e0303c1
	_0x00c10303
	_0x00818181
	_0x00818181
	_0xc103030e
	_0x000e0303
	_0x0000cd67
	_0x00000000
	_0xc6830100
	_0x00ef6c6c
	_0x666663e1
	_0x006666e7
	_0xc70606c7
	_0x00c76666
	_0xc76666c7
	_0x00c76666
	_0x060606e7
	_0x00060606
	_0xc6c6c683
	_0x6cefc6c6
	_0xc70606e7
	_0x00e70606
	_0xc3e7bdbd
	_0x00bdbde7
	_0xc16066c3
	_0x00c36660
	_0xe7e66666
	_0x00666667
	_0xe7e666c3
	_0x00666667
	_0x0787c666
	_0x0066c687
	_0x666663e1
	_0x00666666
	_0xefefee6c
	_0x006c6c6d
	_0xe7666666
	_0x00666666
	_0x666666c3
	_0x00c36666
	_0x666666e7
	_0x00666666
	_0x666666c7
	_0x000606c7
	_0x060666c3
	_0x00c36606
	_0x818181e7
	_0x00818181
	_0xe3666666
	_0x00c36660
	_0xbdbdbde7
	_0x008181e7
	_0x81c36666
	_0x006666c3
	_0x66666666
	_0x30f76666
	_0xe3666666
	_0x00606060
	_0xbdbdbdbd
	_0x00ffbdbd
	_0xbdbdbdbd
	_0x30ffbdbd
	_0xc706060e
	_0x00c76666
	_0x6f6c6c6c
	_0x006feded
	_0xc7060606
	_0x00c76666
	_0xe360c887
	_0x0087c860
	_0xbfbdbdec
	_0x00ecbdbd
	_0x666666e3
	_0x006663e3
	_0xc0870000
	_0x0067ccc7
	_0xc306c300
	_0x00c36666
	_0x66c70000
	_0x00c766c7
	_0x06e70000
	_0x00060606
	_0xc6c30000
	_0x6cefc6c6
	_0x66c30000
	_0x00c306e7
	_0xe7bd0000
	_0x00bde7c3
	_0x66c30000
	_0x00c366c0
	_0xe6660000
	_0x006667e7
	_0xe6668100
	_0x006667e7
	_0xc6660000
	_0x0066c687
	_0x63e10000
	_0x00666666
	_0xef6c0000
	_0x006c6def
	_0x66660000
	_0x006666e7
	_0x66c30000
	_0x00c36666
	_0x66e70000
	_0x00666666
	_0x44114411
	_0x44114411
	_0xaa55aa55
	_0xaa55aa55
	_0x77dd77dd
	_0x77dd77dd
	_0x81818181
	_0x81818181
	_0x8f818181
	_0x81818181
	_0x8f818f81
	_0x81818181
	_0x6f636363
	_0x63636363
	_0xef000000
	_0x63636363
	_0x8f818f00
	_0x81818181
	_0x6f606f63
	_0x63636363
	_0x63636363
	_0x63636363
	_0x6f60ef00
	_0x63636363
	_0xef606f63
	_0x00000000
	_0xef636363
	_0x00000000
	_0x8f818f81
	_0x00000000
	_0x8f000000
	_0x81818181
	_0xf1818181
	_0x00000000
	_0xff818181
	_0x00000000
	_0xff000000
	_0x81818181
	_0xf1818181
	_0x81818181
	_0xff000000
	_0x00000000
	_0xff818181
	_0x81818181
	_0xf181f181
	_0x81818181
	_0x73636363
	_0x63636363
	_0xf3037363
	_0x00000000
	_0x7303f300
	_0x63636363
	_0xff007f63
	_0x00000000
	_0x7f00ff00
	_0x63636363
	_0x73037363
	_0x63636363
	_0xff00ff00
	_0x00000000
	_0x7f007f63
	_0x63636363
	_0xff00ff81
	_0x00000000
	_0xff636363
	_0x00000000
	_0xff00ff00
	_0x81818181
	_0xff000000
	_0x63636363
	_0xf3636363
	_0x00000000
	_0xf181f181
	_0x00000000
	_0xf181f100
	_0x81818181
	_0xf3000000
	_0x63636363
	_0xff636363
	_0x63636363
	_0xff81ff81
	_0x81818181
	_0x8f818181
	_0x00000000
	_0xf1000000
	_0x81818181
	_0xffffffff
	_0xffffffff
	_0xff000000
	_0xffffffff
	_0x0f0f0f0f
	_0x0f0f0f0f
	_0xf0f0f0f0
	_0xf0f0f0f0
	_0x00ffffff
	_0x00000000
	_0x66c70000
	_0x0006c766
	_0x66c30000
	_0x00c36606
	_0x81e70000
	_0x00818181
	_0x66660000
	_0x00c360e3
	_0xbde70000
	_0x0081e7bd
	_0xc3660000
	_0x0066c381
	_0x66660000
	_0x30f76666
	_0x66660000
	_0x006060e3
	_0xbdbd0000
	_0x00ffbdbd
	_0xbdbd0000
	_0x30ffbdbd
	_0x060e0000
	_0x00c766c7
	_0x6c6c0000
	_0x006fed6f
	_0x06060000
	_0x00c766c7
	_0x60c70000
	_0x00c760e3
	_0xbdec0000
	_0x00ecbdbf
	_0x66e30000
	_0x006663e3
	_0x06e70066
	_0x00e706c7
	_0x66c30042
	_0x00c306e7
	_0xc0810300
	_0x0381c060
	_0x0381c000
	_0xc0810306
	_0x81b1b1e0
	_0x81818181
	_0x81818181
	_0x078d8d81
	_0x00818100
	_0x818100e7
	_0x00cd6700
	_0x0000cd67
	_0xc6c68300
	_0x00000083
	_0x00000000
	_0x00000081
	_0x83000000
	_0x00000083
	_0x40602030
	_0x018386cc
	_0x1a9924c3
	_0xc324991a
	_0x02018403
	_0x00000087
	_0xc7c70000
	_0x0000c7c7
	_0x00000000
	_0x00e72400

flocons:
	;un flocon est codé sur 32 bits: 
	;bits 0-7: ancienne couleur
	;bits 8-15: y
	;bits 16-31: x
	_0
