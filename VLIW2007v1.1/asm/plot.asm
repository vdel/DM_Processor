main:
	nop 		/ 	ldi0 0xff
	mov r1 r0 	/ 	ldi0 4
	mov r2 r0 	/ 	ldi0 0
	mov r3 r0 	/ 	sra r15 r0
	jrf plot 	/ 	nop
	jrb main 	/ 	nop
plot:		;; Arguments de plot:
		;; r1: couleur
		;; r2: x
		;; r3: y
		;; r15: adresse de retour
		;; plot affiche un pixel de couleur r1 en x,y
		;; modifie r0 r1 r2 r3 r4
		;; plot ne vérifie pas que les coordonnées sont valides
	mov r4 r2 	/ 	ldi0 2		;on copie x dans r4
	lsr r2 r0 	/ 	ldi0 80		;on divise x par 4: r2 contient l'abscisse en mots de 32 bits
	nez p1 r3 	/ 	dec r3 r3	;Tant que r3=y ne vaut pas 0...
	add r2 r0 	/ 	?p1 jrb 0x1	;...on ajoute 80=360/4 à r2 et on décrémente r3
	sub r2 r0 	/ 	ldi0 3		;on a aouté une fois de trop: on retire 80 à r2
	and r4 r0 	/ 	ldi0 0xff	;r4 contient alors x mod 4, r0 un masque sur 1 octet
	lsl r0 r4 	/ 	lsl r1 r4	;on décale le masque et la couleur pour les ajuster au niveau du bon octet
	ld r3 r2	/ 	not r0 r0	;on charge le mot à modifier dans r3 (et on inverse le masque)
	nop 		/ 	and r3 r0	;on masque
	nop 		/ 	add r3 r1	;on ajoute
	str r3 r2 	/ 	ja r15		;on sauve et on quitte




		
