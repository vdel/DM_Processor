init:
        nop		/ 	ldi0 8
	mov  r4 r0	/	ldi0 0xff
	mov  r5 r0	/	nop
	ldl16 0x4fff
	mov  r10 r0	/ 	nop
	ldl16 0
	mov r1 r0 	/ 	mov r2 r0 
boucle:
	add r3 r2 	/ 	inc  r2 r2 
	lsl r3 r4  	/       and  r2 r5
	add r3 r2 	/ 	inc  r2 r2 
	lsl r3 r4  	/       and  r2 r5
	add r3 r2 	/ 	inc  r2 r2 
	lsl r3 r4  	/       and  r2 r5
	add r3 r2 	/ 	inc  r2 r2 
  	str r3 r1	/       and  r2 r5	
	mov r3 r0 	/ 	inc r1 r1 
	dec r10 r10	/ 	nop
	nez p1 r10	/ 	nop 
	?p1 jrb boucle 	/ 	nop 

	;; effacer
	ldl16 0x4fff
	mov r1 r0	/ 	nop
	ldl16 0
boucle_eff:
	str r0 r1 	/	nez p1 r1
	dec r1 r1	/	?p1 jrb boucle_eff

	nop		/ 	jrb init