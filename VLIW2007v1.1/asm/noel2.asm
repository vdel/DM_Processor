	nop		/	ldi0 33
	mov r11 r0	/	ldi0 93		;126-33
	mov r12	r0	/	ldi0 0xff
	mov r4 r0	/	ldi0 0
	mov r2 r0	/	mov r3 r0
main:
	nez p7 r12	/	nop
	mov r1 r11	/	sra r15
	jrf putc	/	inc r11 r11
	?p7 jrb main	/	dec r12 r12	;on boucle pour afficher les caratères 33 à 126
  	inc r3 r3	/	ldi0 0
	inc r3 r3	/	mov r2 r0	;on saute deux lignes
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
	sra r15		/	ldi0 32		;on boucle en affichant un espace
	jrf putc	/	mov r1 r0
	jrb 2		/	nop


putc:		;; Argurments de putc:	
		;; r1: caractère à afficher
		;; r2: colonne où afficher
		;; r3: ligne où afficher
		;; r4: couleur
		;; r15: adresse de retour
		;; putc affiche un caractère et met à jour le curseur
		;; modifie r0 r1 r2 r3 r5 r6 r7 r8 r9 r10 r13 r14 r15 p1
		;; putc ne vérifie pas que les coordonnées initiales sont valides
	inc r9 r2	/	mov r10 r3	;on stocke la nouvelle colonne dans r9, la ligne courante dans r10
	mov r13 r15	/	ldi0 0xFF		;on sauve l'adresse de retour
	sra r15		/	and r4 r0	;on masque la couleur (au cas ou...)
	jrf putcxy	/	nop		
	mov r5 r9	/	ldi0 40     	;on vérifie que on sort pas de l'écran
	sub r5 r0	/	ldi0 31     	;r5 <- (x+1) - 40
	gez p1 r5 	/	mov r6 r10
	?p1 jrf	3	/	sub r6 r0	;si (x+1) < 40 alors:
	mov r2 r9	/	mov r3 r10	;  x <- x+1 et y<-y
	ja r13		/	nop		;  fin de putc
	lsz p1 r6       /	ldi0 0		;sinon
	?p1 inc r10 r10	/	mov r2 r0	;  x<-0 et si y<31 alors y<-y+1
	ja r13		/	mov r3 r10

putcxy:		;; Argurments de putcxy:	
		;; r1: caractère à afficher
		;; r2: colonne où afficher
		;; r3: ligne où afficher
		;; r4: couleur
		;; r15: adresse de retour
		;; putcxy ne vérifie ni les coordonnées, ni la couleur
		;; modifie r0 r1 r2 r3 r5 r6 r7 r8 r14 p1
		;; 252 instructions pour afficher un caractère en 0,0

	eqz p1 r3	/	ldi0 1      	;à droite: début routine
	lsl r1 r0	/	lsl r2 r0   	;on multiplie r2 par 2 pour avoir la bonne colonne
	 					;on multiplie r1 par deux car chaque carac est codé sur 2 octets.
	?p1 jrf ptcxy_endwhile / dec r3 r3	;si y=0, on passe à la suite, sinon il faut ajuster r2
	ldl16 640 				;décalage mémoire à effectuer pour passer à la ligne suivante 
ptcxy_while:					;tant que r3>0,
	nez p1 r3	/	dec r3 r3	;on ajoute 640 à r2 pour arriver à la bonne ligne
	?p1 jrb ptcxy_while /	add r2 r0
ptcxy_endwhile:			
	ldl32 putcxy_codes
	add r1 r0	/	ldi0 1	   	;dans r1, adresse mémoire du premier mot du caractère
	ld r5 r1	/	mov r3 r0    	;premier mot dans r5			
	inc r1 r1	/	ldi0 79		;dans r1, adresse mémoire du second mot du caractère	
	mov r7 r0	/	nop
						; On récapitule:
						; r1: adresse mémoire de la demi-matrice inférieure
						; r2: adresse vidéo du coin supérieur gauche où afficher
						; r3=1: pour décaler le code du caractère vers la droite
						; r4: couleur
						; r5: demi-matrice supérieur
						; r6=8: pour décalage de la couleur  (cf ci-dessous)
						; r7=79: pour passer à la ligne suivante de l'écran (en décalant d'un pixel à gauche)
						; r8: vide
	sra r14		/	ldi0 8
	jrf ptcxy_hl	/ 	mov r6 r0	;ligne 0, gauche
	str r0 r2	/	sra r14
	jrf ptcxy_hl	/ 	inc r2 r2	;ligne 0, droite
	str r0 r2	/	sra r14
	jrf ptcxy_hl	/ 	add r2 r7	;ligne 1, gauche
	str r0 r2	/	sra r14
	jrf ptcxy_hl	/ 	inc r2 r2	;ligne 1, droite
	str r0 r2	/	sra r14
	jrf ptcxy_hl	/ 	add r2 r7	;ligne 2, gauche
	str r0 r2	/	sra r14
	jrf ptcxy_hl	/ 	inc r2 r2	;ligne 2, droite
	str r0 r2	/	sra r14
	jrf ptcxy_hl	/ 	add r2 r7	;ligne 3, gauche
	str r0 r2	/	sra r14
	jrf ptcxy_hl	/ 	inc r2 r2	;ligne 3, droite
	ld r5 r1	/	nop
	str r0 r2	/	sra r14
	jrf ptcxy_hl	/ 	add r2 r7	;ligne 4, gauche
	str r0 r2	/	sra r14
	jrf ptcxy_hl	/ 	inc r2 r2	;ligne 4, droite
	str r0 r2	/	sra r14
	jrf ptcxy_hl	/ 	add r2 r7	;ligne 5, gauche
	str r0 r2	/	sra r14
	jrf ptcxy_hl	/ 	inc r2 r2	;ligne 5, droite
	str r0 r2	/	sra r14
	jrf ptcxy_hl	/ 	add r2 r7	;ligne 6, gauche
	str r0 r2	/	sra r14
	jrf ptcxy_hl	/ 	inc r2 r2	;ligne 6, droite
	str r0 r2	/	sra r14
	jrf ptcxy_hl	/ 	add r2 r7	;ligne 7, gauche
	str r0 r2	/	sra r14
	jrf ptcxy_hl	/ 	inc r2 r2	;ligne 7, droite
	str r0 r2	/	nop
	ja r15		/	nop
ptcxy_hl:  	;calcule la valeur d'un mot de 32 bits (=1/2 ligne) pour l'affichage
		;a besoin de r0=4 r3=1 r4=couleur r6=8 r8=vide, renvoit le résultat dans r0
	mov r8 r5	/	nop
	and r8 r3	/	lsr r5 r3		;r8<-bits de poids faible de r5
	nez p1 r8	/	ldi0 0			;bits de poids faible vaut 1?, résultat dans r0
	mov r8 r5	/	?p1 add r0 r4		;on ajoute la couleur à r0
	and r8 r3	/	lsr r5 r3		;on décale r0 et on recommence 4 fois
	nez p1 r8	/	lsl r0 r6
	mov r8 r5	/	?p1 add r0 r4
	and r8 r3	/	lsr r5 r3
	nez p1 r8	/	lsl r0 r6
	mov r8 r5	/	?p1 add r0 r4
	and r8 r3	/	lsr r5 r3
	nez p1 r8	/	lsl r0 r6
	ja r14		/	?p1 add r0 r4
putcxy_codes:
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






