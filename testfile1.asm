    .section startup
    .org    0

    jmp main

	2

    .data
aw: .word   2345
bw: .word   6789
cw: .word

ab: .word   0xaa
bb: .word   0xbb
cb: .word

    .text
main:
    ld      r0, aw
    ld      r1, bw
    jmpl    sum
    st      r0, cw

    ldb     r0, ab
    ldb     r1, bb
    jmpl    sum
    stb     r0, cb

sum:
    add     r0, r0, r1
    ret

    .end
/* ---------------------------------------------------------------------
	int sum(int a, int b) {
		return a + b;
	}
*/

sum:
	add		r0, r0, r1
	ret

/* ---------------------------------------------------------------------
	r0		r0		r1
	int mul(int m, int n) {
		int res = 0; r2
		while (n > 0) {
			res += m;
			n -= 1;
		}
		return res;
	}
*/


	.data

mul_r5:	.word
mul_m:	.word
mul_n:	.word

	.text
mul:
	st		r5, mul_r5
	ldi		r2, #0
	sub		r1, r1, #0
	jz		L1
L2:
	st		r1, mul_n
	ld		r0, mul_m
	mov		r1, r2
	jmpl	sum
	mov		r2, r0
	ld		r1, mul_n
	dec		r1
	jnz		L2
L1:
	mov		r0, r2
	ld		r5, mul_r5

/* ---------------------------------------------------------------------
						r0		r1		r2		r3
	void mul_array(int a[], int b[], int c[], int dim) {
		int i;
		for (i = 0; i < dim; ++i)
			c[i] = mul(a[i], b[i]);
	}
*/
	.data
mul_array_r5:	.word
mul_array_a:	.word
mul_array_b:	.word
mul_array_c:	.word
mul_array_dim:	.word

	.text
mul_array:
		st		r5, mul_array_r5
		st		r0, mul_array_a
		st		r1, mul_array_b
		st		r2, mul_array_c
		st		r3, mul_array_dim
		
		ldi		r4, #0
		sub		r6, r4, r3
		jnc		mul_array_1
mul_array_2:
		ld		r0, mul_array_a
		ld		r0, [r0, r4]
		ld		r1, mul_array_b
		ld		r1, [r1, r4]
		jmpl	mul
		ld		r1, mul_array_c
		st		r0, [r1, r4]
		inc		r4
		sub		r6, r4, r3
		jc		mul_array_2

mul_array_1:
		ld		r5, mul_array_r5
/* ---------------------------------------------------------------------
	int sum(int a, int b) {
		return a + b;
	}
*/

sum:
	add		r0, r0, r1
	ret

/* ---------------------------------------------------------------------
	r0		r0		r1
	int mul(int m, int n) {
		int res = 0; r2
		while (n > 0) {
			res += m;
			n -= 1;
		}
		return res;
	}
*/


	.data

mul_r5:	.word
mul_m:	.word
mul_n:	.word

	.text
mul:
	st		r5, mul_r5
	ldi		r2, #0
	sub		r1, r1, #0
	jz		L1
L2:
	st		r1, mul_n
	ld		r0, mul_m
	mov		r1, r2
	jmpl	sum
	mov		r2, r0
	ld		r1, mul_n
	dec		r1
	jnz		L2
L1:
	mov		r0, r2
	ld		r5, mul_r5

/* ---------------------------------------------------------------------
						r0		r1		r2		r3
	void mul_array(int a[], int b[], int c[], int dim) {
		int i;
		for (i = 0; i < dim; ++i)
			c[i] = mul(a[i], b[i]);
	}
*/
	.data
mul_array_r5:	.word
mul_array_a:	.word
mul_array_b:	.word
mul_array_c:	.word
mul_array_dim:	.word

	.text
mul_array:
		st		r5, mul_array_r5
		st		r0, mul_array_a
		st		r1, mul_array_b
		st		r2, mul_array_c
		st		r3, mul_array_dim
		
		ldi		r4, #0
		sub		r6, r4, r3
		jnc		mul_array_1
mul_array_2:
		ld		r0, mul_array_a
		ld		r0, [r0, r4]
		ld		r1, mul_array_b
		ld		r1, [r1, r4]
		jmpl	mul
		ld		r1, mul_array_c
		st		r0, [r1, r4]
		inc		r4
		sub		r6, r4, r3
		jc		mul_array_2

mul_array_1:
		ld		r5, mul_array_r5
/* Este código foi feito na aula. Tem muitos erros!!!*/
	.section startup
	.org 0
	jmp	main
	
	.data
save_lr:	.word

block1:		.byte	10, 20, 30, 40, 50
block2:		.space	5
size:		.word

	.text
main:
	ldi		r0, #low(block2)
	ldih	r0, #high(block2)
	ldi		r1, #low(block1)
	ldih	r1, #high(block1)
	ld		r2, size
	jmpl	copy_block
	jmp		$

/* void copy_block(byte dst[], byte src[], size_t size)
						r0			r1			r2
*/

copy_block:
	st		r5, save_lr
	sub		r6, r0, r1
	jc		l1
	;	endereço destino maior, começar do fim do bloco
	;	alinhar para endereços pares
	add		r1, r1, r2		; r1, r0 - endereços do fim do bloco (past the end)
	add		r0, r0, r2	
	xrl		r3, r0, r1
	shr		r6, r3, #1, 0
	jc		l100			; cópia byte-a-byte decrescente
	anl		r3, r0, r1		
	shr		r6, r0, #1, 0
	jnc		l11				; já está alinhado

	;  copiar um byte para alinhar a endereços de word
	dec		r1
	dec		r0
	ldb		r3, [r1, #0]
	stb		r3, [r0, #0]
	dec		r2				
	
l11:
	shr		r4, r2, #1, 0	; r4 - nº words a copiar
l13:	
	anl		r4, r4, r4		; enquanto existirem words
	jz		l12
	sub		r1, r1, #2		; decrementar os endereços para a próxima word
	sub		r0, r0, #2
	ld		r3, [r1, #0]	; copiar uma word
	st		r3, [r0, #0]
	dec		r4				; decrementar o contador de words
	jmp		l13

l12:						; falta o último byte?
	shr		r6, r2, #1, 0
	jnc		l14
	ldb		r3, [r1, #-1]
	stb		r3, [r0, #-1]
l14:
	ld		r5, save_lr
	ret
	
l100:			; cópiar byte-a-byte decrescente
	ld		r5, save_lr
	ret

;-------------------------------------------------------------------------------

l1:
	;	endereço destino menor, avançar em endereços crescentes
	;	alinhar para endereços pares
	anl		r3, r0, r1
	shr		r6, r3, #1, 0
	jnc		l2
	ldb		r3, [r1, #0]
	stb		r3, [r0, #0]
	dec		r2
l2:
	;	copiar word-a-word
	shr		r4, r2, #1, 0
	ldi		r5, #0
l3:
	sub		r6, r5, r4
	jnc		l4
	ld		r3, [r1, r5]
	st		r3, [r0, r5]
	add		r5, r5, #1
	jmp		l3
l4:
	;	copiar o último byte
	shr		r6, r2, #1, 0
	jnc		l5
	dec		r2
	ldb		r3, [r1, r2]
	stb		r3, [r0, r2]
l5:
	ld		r5, save_lr
	ret
	
.end
	.section	startup
	.org	0
	jmp		main
	
	.data
save_lr:	.word

a:			.word 20, 30, 1, 7, 8, 9
n:			.word ($ - a) / 2
greatest:	.word

	.text

main:
	ldi		r0, #low(a)
	ldih	r0, #high(a)
	ld		r1, n
	jmpl	find_greatest
	jmp		$
	
/*
r0					r0		r1
int find_greatest( int a[], int n ){
	int i, p;
	for( p = 0, i = 1 ; i < n ; ++i )
		if( a[i] > a[p] )
			p = i;
	return p;
}

	r2 - i
	r3 - p
*/

find_greatest:
	st		r5, save_lr
	ldi		r3, #0			;	p = 0
	ldi		r2, #1			;	i = 1
l1:
	sub		r6, r2, r1		;	i < n
	jnc		l2
	ld		r4, [r0, r2]	;	a[i]
	ld		r5, [r0, r3]	;	a[p]
	sub		r6, r4, r5		;	a[i] > a[p]
	jz		l3
	jc		l3
	mov		r3, r2			;	p = i
l3:
	add		r2, r2, #1		;	++i
	jmp		l1
l2:
	mov		r0, r3			;	return p
	ld		r5, save_lr
	ret
	.section startup
	.org	0
	jmp		main
	
	.data
multiplicando:
	.word	0x101
multiplicador:
	.word	0x102
resultado:
	.word
	.word

	.text
main:
	ld		r0, multiplicador
	ld		r1, multiplicando
	jmpl	multiplicacao
	st		r0, resultado + 2
	st		r1, resultado

	jmp		$

/*
	multplicando				r4:r0
	multiplicador				   r1
	acumulaÃ§Ã£o de resultado		r3:r2
*/

/* Este cÃ³digo nÃ£o foi testado */

multiplicacao:
	ldi		r2, #0
	ldi		r3, #0
	ldi		r4, #0
L2:
	shr		r1, r1, #1, 0
	jnc		L1
	add		r2, r2, r0		/*	r3:r2 = r3:r2 + r4:r0
	adc		r3, r3, r4
L1:
	shl		r0, r0, #1, 0	/*	r4:r0 = r4:r0 << 1
	rcl		r4, r4
	sub		r1, r1, #0
	jnz		L2
	mov		r0, r2
	mov		r1, r3
	ret
	
	.end
	
	
	.section startup
	.org	0
	jmp		main
	
	.data
multiplicando:
	.byte	3
multiplicador:
	.byte	5
resultado:
	.word

multiplicando2:
	.byte	3
multiplicador2:
	.byte	5
resultado2:
	.word
	
	.text
main:
	ldb		r0, multiplicador
	ldb		r1, multiplicando
	jmpl	multiplicacao
	st		r0, resultado

	ldb		r0, multiplicador2
	ldb		r1, multiplicando2
	jmpl	multiplicacao
	st		r0, resultado2

	jmp		$
	
/*
	r0					r0		r1
	int multiplicacao(int m, int n) {
		int res = 0;
		while (n > 0) {
			res += m;
			n -= 1;
		}
		return res;
	}
*/

/*
multiplicacao:
	ldi		r2, #0
	sub		r1, r1, #0
	jz		L1
L2:
	add		r2, r2, r0
	dec		r1
	jnz		L2
L1:
	mov		r0, r2
	ret
*/

multiplicacao:
	ldi		r2, #0
L2:
	shr		r1, r1, #1, 0
	jnc		L1
	add		r2, r2, r0
L1:
	shl		r0, r0, #1, 0
	sub		r1, r1, #0
	jnz		L2
	mov		r0, r2
	ret
	
	.end
	
		.section startup
	.org 0
	jmp	main
	
	.data
save_lr:	.word

array:		.word 10, 20, 30, 40, 50
nel:		.word 5 ;($ - array)
val:		.word 35
position:	.word

	.text
main:
	ldi		r0, #low(array)
	ldih	r0, #high(array)
	ld		r1, nel
	ld		r2, val
	jmpl	sorted_search
	st		r0, position
	jmp		$

/*
r0						r0			r1		r2
int sorted_search( int arr[], int n_el, int val ){
	int i; r3
	for( i = 0 ; i != n_el && arr[i] < val ; ++i )
		;
	if( i == n_el || arr[i] != val )
		return -i;
	return i;
}
*/

sorted_search:
	ldi		r3, #0			;	i = 0
l1:
	sub		r6, r3, r1		; i != n_el
	jz		l2
	ld		r4, [r0, r3]
	sub		r6, r4, r2		; arr[i] < val
	jnc		l2
	inc		r3
	jmp		l1
l2:							; if
	sub		r6, r3, r1		; i == n_el
	jz		l3
	sub		r6, r4, r2		; || arr[i] != val
	jz		l4
l3:
	not		r0, r3			; return -i;
	inc		r0
	ret
l4:
	mov		r0, r3			; return i;
	ret
	
.end
/* Este código foi feito na aula. Tem muitos erros!!!
*/
	.section startup
	.org 0
	jmp	main
	
	.data
save_lr:	.word

block1:		.byte	10, 20, 30, 40, 50
block2:		.space	5
size:		.word

	.text
main:
	ldi		r0, #low(block2)
	ldih	r0, #high(block2)
	ldi		r1, #low(block1)
	ldih	r1, #high(block1)
	ld		r2, size
	jmpl	copy_block
	jmp		$

/* void copy_block(byte dst[], byte src[], size_t size)
						r0			r1			r2
*/

copy_block:
	st		r5, save_lr
	sub		r6, r0, r1
	jc		l1
	;	endereço destino maior, começar do fim do bloco
	;	alinhar para endereços pares
	add		r1, r1, r2		; r1, r0 - endereços do fim do bloco (past the end)
	add		r0, r0, r2	
	xrl		r3, r0, r1
	shr		r6, r3, #1, 0
	jc		l100			; cópia byte-a-byte decrescente
	anl		r3, r0, r1		
	shr		r6, r0, #1, 0
	jnc		l11				; já está alinhado

	;  copiar um byte para alinhar a endereços de word
	dec		r1
	dec		r0
	ldb		r3, [r1, #0]
	stb		r3, [r0, #0]
	dec		r2				
	
l11:
	shr		r4, r2, #1, 0	; r4 - nº words a copiar
l13:	
	anl		r4, r4, r4		; enquanto existirem words
	jz		l12
	sub		r1, r1, #2		; decrementar os endereços para a próxima word
	sub		r0, r0, #2
	ld		r3, [r1, #0]	; copiar uma word
	st		r3, [r0, #0]
	dec		r4				; decrementar o contador de words
	jmp		l13

l12:						; falta o último byte?
	shr		r6, r2, #1, 0
	jnc		l14
	ldb		r3, [r1, #-1]
	stb		r3, [r0, #-1]
l14:
	ld		r5, save_lr
	ret
	
l100:			; cópiar byte-a-byte decrescente
	ld		r5, save_lr
	ret

;-------------------------------------------------------------------------------

l1:
	;	endereço destino menor, avançar em endereços crescentes
	;	alinhar para endereços pares
	anl		r3, r0, r1
	shr		r6, r3, #1, 0
	jnc		l2
	ldb		r3, [r1, #0]
	stb		r3, [r0, #0]
	dec		r2
l2:
	;	copiar word-a-word
	shr		r4, r2, #1, 0
	ldi		r5, #0
l3:
	sub		r6, r5, r4
	jnc		l4
	ld		r3, [r1, r5]
	st		r3, [r0, r5]
	add		r5, r5, #1
	jmp		l3
l4:
	;	copiar o último byte
	shr		r6, r2, #1, 0
	jnc		l5
	dec		r2
	ldb		r3, [r1, r2]
	stb		r3, [r0, r2]
l5:
	ld		r5, save_lr
	ret
	
.end
	.section	startup
	.org	0
	jmp		main
	
	.data
save_lr:	.word

a:			.word 20, 30, 1, 7, 8, 9
n:			.word ($ - a) / 2
greatest:	.word

	.text

main:
	ldi		r0, #low(a)
	ldih	r0, #high(a)
	ld		r1, n
	jmpl	find_greatest
	jmp		$
	
/*
r0					r0		r1
int find_greatest( int a[], int n ){
	int i, p;
	for( p = 0, i = 1 ; i < n ; ++i )
		if( a[i] > a[p] )
			p = i;
	return p;
}

	r2 - i
	r3 - p
*/

find_greatest:
	st		r5, save_lr
	ldi		r3, #0			;	p = 0
	ldi		r2, #1			;	i = 1
l1:
	sub		r6, r2, r1		;	i < n
	jnc		l2
	ld		r4, [r0, r2]	;	a[i]
	ld		r5, [r0, r3]	;	a[p]
	sub		r6, r4, r5		;	a[i] > a[p]
	jz		l3
	jc		l3
	mov		r3, r2			;	p = i
l3:
	add		r2, r2, #1		;	++i
	jmp		l1
l2:
	mov		r0, r3			;	return p
	ld		r5, save_lr
	ret
	.section startup
	.org	0
	jmp		main
	
	.data
multiplicando:
	.word	0x101
multiplicador:
	.word	0x102
resultado:
	.word
	.word

	.text
main:
	ld		r0, multiplicador
	ld		r1, multiplicando
	jmpl	multiplicacao
	st		r0, resultado + 2
	st		r1, resultado

	jmp		$

/*
	multplicando				r4:r0
	multiplicador				   r1
	acumulaÃ§Ã£o de resultado		r3:r2
*/

/* Este cÃ³digo nÃ£o foi testado */

multiplicacao:
	ldi		r2, #0
	ldi		r3, #0
	ldi		r4, #0
L2:
	shr		r1, r1, #1, 0
	jnc		L1
	add		r2, r2, r0		/*	r3:r2 = r3:r2 + r4:r0
	adc		r3, r3, r4
L1:
	shl		r0, r0, #1, 0	/*	r4:r0 = r4:r0 << 1
	rcl		r4, r4
	sub		r1, r1, #0
	jnz		L2
	mov		r0, r2
	mov		r1, r3
	ret
	
	.end
	
	
	.section startup
	.org	0
	jmp		main
	
	.data
multiplicando:
	.byte	3
multiplicador:
	.byte	5
resultado:
	.word

multiplicando2:
	.byte	3
multiplicador2:
	.byte	5
resultado2:
	.word
	
	.text
main:
	ldb		r0, multiplicador
	ldb		r1, multiplicando
	jmpl	multiplicacao
	st		r0, resultado

	ldb		r0, multiplicador2
	ldb		r1, multiplicando2
	jmpl	multiplicacao
	st		r0, resultado2

	jmp		$
	
/*
	r0					r0		r1
	int multiplicacao(int m, int n) {
		int res = 0;
		while (n > 0) {
			res += m;
			n -= 1;
		}
		return res;
	}
*/

/*
multiplicacao:
	ldi		r2, #0
	sub		r1, r1, #0
	jz		L1
L2:
	add		r2, r2, r0
	dec		r1
	jnz		L2
L1:
	mov		r0, r2
	ret
*/

multiplicacao:
	ldi		r2, #0
L2:
	shr		r1, r1, #1, 0
	jnc		L1
	add		r2, r2, r0
L1:
	shl		r0, r0, #1, 0
	sub		r1, r1, #0
	jnz		L2
	mov		r0, r2
	ret
	
	.end
	
		.section startup
	.org 0
	jmp	main
	
	.data
save_lr:	.word

array:		.word 10, 20, 30, 40, 50
nel:		.word 5 ;($ - array)
val:		.word 35
position:	.word

	.text
main:
	ldi		r0, #low(array)
	ldih	r0, #high(array)
	ld		r1, nel
	ld		r2, val
	jmpl	sorted_search
	st		r0, position
	jmp		$

/*
r0						r0			r1		r2
int sorted_search( int arr[], int n_el, int val ){
	int i; r3
	for( i = 0 ; i != n_el && arr[i] < val ; ++i )
		;
	if( i == n_el || arr[i] != val )
		return -i;
	return i;
}
*/

sorted_search:
	ldi		r3, #0			;	i = 0
l1:
	sub		r6, r3, r1		; i != n_el
	jz		l2
	ld		r4, [r0, r3]
	sub		r6, r4, r2		; arr[i] < val
	jnc		l2
	inc		r3
	jmp		l1
l2:							; if
	sub		r6, r3, r1		; i == n_el
	jz		l3
	sub		r6, r4, r2		; || arr[i] != val
	jz		l4
l3:
	not		r0, r3			; return -i;
	inc		r0
	ret
l4:
	mov		r0, r3			; return i;
	ret
	
.end
	.equ	IO_PORT_ADDR, 0xff00
	.equ	IE_MASK, 10000
	.equ	ID_MASK, 00000
	.equ	CONST_1_SEG, 125
	.equ	VAL_CONT_IMPULSOS, 6

	.section startup
	.org	0
	jmp	main
	jmp	isr_entry

	.data
sp:
	.word

stack_buffer:
	.space	10 * 10 * 2

pulse_counter:
	.byte

	.text

clear_interrupt_request:
	ldi	r0, #low(IO_PORT_ADDR)
	ldih	r0, #high(IO_PORT_ADDR)
	ldi	r1, #1
	stb	r1, [r0, #1]
	ldi	r1, #0
	stb	r1, [r0, #1]
	ret

isr_entry:
	ld	r1, sp
	st	r5, [r1, #0]	; push LINK
	st	r0, [r1, #1]	; push PSW
	add	r1, r1, #4 	; update SP
	st	r1, sp
	jmpl	clear_interrupt_request
	ldb	r0, pulse_counter        ; incrementa contador de impulsos
	inc	r0
	stb	r0, pulse_counter
isr_return:
	ld	r1, sp
	sub	r1, r1, #4
	ld	r0, [r1, #1]    ; pop PSW
	ld	r5, [r1, #0]    ; pop LINK
	st	r1, sp
	iret

; void delay(int seconds)
delay:
	ldi	r1, #CONST_1_SEG
delay_1:
	dec	r1            ;4ms
	jnz	delay_1       ;4ms
	dec	r0            
	jnz	delay
	ret

main:
	;iniciar stack pointer de interrupção
	ldi	r0, #low(stack)
	ldih	r0, #high(stack)
	st	r0, sp
main_1:                
	ldi	r0, #0
	stb	r0, pulse_counter
	jmpl	clear_interrupt_request
	ldi	r6, #IE_MASK		; desinibir interrupções
main_2:
	ld	r0, pulse_counter	; esperar pela activaçao de B
	anl	r0, r0, r0
	jz	main_2	
	ldi	r0, #10		        ; delay de 10 segundos
	jmpl	delay
	ldi	r6, #ID_MASK		; inibir interrupções
	ldb	r1, pulse_counter
	ldi	r0, #VAL_CONT_IMPULSOS
	sub	r6, r0, r1
	jnz	main_1			; do while (pulse_counter != VAL_CONT_IMPULSOS)
	jmpl	actuar_A		; rotina que realizaria a activação da saída A    
	jmp	main_1

	.equ	LAMP, 1
	.equ	LAMP_TIME, 10
	.equ	PORT_ADDR, 0xff
	.equ	B_POS, 1

	.section startup
	.org	0
	jmp	main
	ld	r7, [r7, #0]    ;long jump
	.word	lamp_isr

	.section dada
lamp_time:
	.word	0

	.section text

button_get_transition:
	ldb	r1, [r2, #0]
	shr	r6, r1, #B_POS, 0		; cy = B
	jc	button_get_transition
button_get_transition_1:
	ldb	r1, [r2, #0]
	shr	r6, r1, #B_POS, 0 		; cy = B
	jnc	button_get_transition_1
	ret

; void lamp_set(int val)
lamp_set:
	ldi	r6, #0		; disable interrupt            
	st	r0, lamp_time	; lamp_time = val
	ldi	r0, #LAMP	; lamp on
	stb	r0, [r2, #0]
	ldi	r6, #0x10	; enable interrupt
	ret

main:    
	ldi	r2, #low(PORT_ADDR)
	ldih	r2, #high(PORT_ADDR)
	ldi	r0, #0            
	stb	r0, [r2, #0]         ;lamp off
main_1:
	jmpl	button_get_transition
	ldi	r0, #LAMP_TIME
	jmpl	lamp_set
	jmp	main_1

lamp_isr:
	ld	r2, lamp_time
	dec	r2
	st	r2, lamp_time
	jnz	lamp_isr_1
	ldi	r2, #low(PORT_ADDR)
	ldih	r2, #high(PORT_ADDR)
	ldi	r1, #0
	st	r1, [r2, #0]	;lamp off
	ldi	r0, #0		;disable interrupt
lamp_isr_1:
	iret
/* ---------------------------------------------------------------------
	int sum(int a, int b) {
		return a + b;
	}
*/

sum:
	add		r0, r0, r1
	ret

/* ---------------------------------------------------------------------
	r0		r0		r1
	int mul(int m, int n) {
		int res = 0; r2
		while (n > 0) {
			res += m;
			n -= 1;
		}
		return res;
	}
*/


	.data

mul_r5:	.word
mul_m:	.word
mul_n:	.word

	.text
mul:
	st		r5, mul_r5
	ldi		r2, #0
	sub		r1, r1, #0
	jz		L1
L2:
	st		r1, mul_n
	ld		r0, mul_m
	mov		r1, r2
	jmpl	sum
	mov		r2, r0
	ld		r1, mul_n
	dec		r1
	jnz		L2
L1:
	mov		r0, r2
	ld		r5, mul_r5

/* ---------------------------------------------------------------------
						r0		r1		r2		r3
	void mul_array(int a[], int b[], int c[], int dim) {
		int i;
		for (i = 0; i < dim; ++i)
			c[i] = mul(a[i], b[i]);
	}
*/
	.data
mul_array_r5:	.word
mul_array_a:	.word
mul_array_b:	.word
mul_array_c:	.word
mul_array_dim:	.word

	.text
mul_array:
		st		r5, mul_array_r5
		st		r0, mul_array_a
		st		r1, mul_array_b
		st		r2, mul_array_c
		st		r3, mul_array_dim
		
		ldi		r4, #0
		sub		r6, r4, r3
		jnc		mul_array_1
mul_array_2:
		ld		r0, mul_array_a
		ld		r0, [r0, r4]
		ld		r1, mul_array_b
		ld		r1, [r1, r4]
		jmpl	mul
		ld		r1, mul_array_c
		st		r0, [r1, r4]
		inc		r4
		sub		r6, r4, r3
		jc		mul_array_2

mul_array_1:
		ld		r5, mul_array_r5
	.section startup
	.org	0

	jmp		main

	.data
	
a:	.word	3
b:	.word	4
c:	.word
	
	.text
main:
	ldi		r0,#0x55
	mov		r6, r0
	ld		r0, a
	ld		r1, b
	jmpl	div
	st		r0, c
	jmp		$

/*------------------------------------------------------*/
	/* r0 = dividendo, r1 = divisor */
	/* r0 = quociente, r1 = resto */
div:
	ldi		r3, #0
	ldi		r4, #0
	ldi		r5, #16
div_3:
	shl		r0, r0, #1, 0
	rcl		r3, r3
	sub		r3, r3, r1
	jc		div_1
	sub		r3, r3, r1
	shl		r4, r4, #1, 1
	jmp		div_2
div_1:
	shl		r4, r4, #1, 0
div_2:
	dec		r5
	jnz		div_3
	mov		r1, r3
	mov		r0, r4
	ret
	
	.end
/*
byte input_state(byte position);
*/

input_state:
	ldi		r1, #7
	sub		r1, r1, r0
	ldi		r0, #low(INPUT_PORT_ADDRESS)
	ldih	r0, #high(INPUT_PORT_ADDRESS)
	ldb		r0, [r0, #0]
	add		pc, pc, r1
	shr		r0, r0, #1, 0
	shr		r0, r0, #1, 0
	shr		r0, r0, #1, 0
	shr		r0, r0, #1, 0
	shr		r0, r0, #1, 0
	shr		r0, r0, #1, 0
	shr		r0, r0, #1, 0
	ret


input_state:
	mov		r1, r0
	ldi		r0, #low(INPUT_PORT_ADDRESS)
	ldih	r0, #high(INPUT_PORT_ADDRESS)
	ldb		r0, [r0, #0]
	sub		r1, r1, #0
	jz		input_state1
input_state2:
	shr		r0, r0, #1, 0
	sub		r1, r1, #1
	jnz		input_state2
input_state1:
	ret
	.section startup
	.org	0

	jmp		main
	
	
	.text
main:
	ldi		r0, #3
	ldi		r1, #4
	jmpl	mul
	jmp		$
	
mul:
	ldi		r2, #8
	ldi		r3, #0
	anl		r2, r2, r2
	jz		mul_end
mul_2:
	shr		r1, r1, #1, 0
	jnc		mul_1
	add		r3, r3, r0
mul_1:
	shl		r0, r0, #1, 0
	dec		r2
	jmp		mul_2
mul_end:
	mov		r0, r3
	ret
	
	.end	.section startup
	.org	0

	jmp		main

	.data
	
a:	.word	3
b:	.word	4
c:	.word

	.text
main:
	ld		r0, a
	ld		r1, b
	jmpl	mul
	st		r0, c
	jmp		$

/*------------------------------------------------------
	r0 = multiplicando, r1 = multiplicador
	r1:r0 = produto
*/

mul:
	ldi		r2, #0
	ldi		r3, #0
	ldi		r4, #0
	anl		r2, r2, r2
	;errado
	jz		mul_end
mul_2:
	shr		r1, r1, #1, 0
	jnc		mul_1
	add		r3, r3, r0
	adc		r4, r4, r2
mul_1:
	shl		r0, r0, #1, 0
	rcl		r2, r2
	dec		r2
	jmp		mul_2
mul_end:
	mov		r0, r3
	mov		r1, r4
	ret
	
	.end
	.section startup
	.org	0

	jmp		main
	
	.data

a:	.word 	20, 23, 2, 10, 5
b:


	.text
main:
	ldi		r0, #low(a)
	ldih	r0, #high(a)
	ldi		r1, #(b - a) / 2
	jmpl	sort
	jmp		$


/* ---------------------------------------------------------------------------
void sort(int array[], int size) {
	int i, j;
	for (i = 0; i < size - 1; ++i)
		for (j = 0; j < size - 1 - i; ++j)
			if (array[j] > array[j + 1]) {
				int aux = array[j];
				array[j] = array[j + 1]
				array[j + 1] = aux;
			}
}

r0 - array
r1 - size
r2 - i
r3 - j
*/

	.data
sort_r2:
	.word
sort_r3:
	.word
sort_r5:
	.word
	
	.text
sort:
	st		r2, sort_r2
	st		r3, sort_r3
	st		r5, sort_r5
	
	dec		r1				;	r1 = size - 1
	
	ldi		r2, #0			;	i = 0
sort_5:
	sub		r6, r2, r1		;	i < size - 1
	jnc		sort_1
	
	ldi		r3, #0			;	j = 0
sort_4:	
	sub		r4, r1, r2
	sub		r6, r3, r4		;	j < size - 1 - i
	jnc		sort_2
	
	ld		r4, [r0, r3]
	inc		r3
	ld		r5, [r0, r3]
	dec		r3
	sub		r6, r4, r5		;	array[j] > array[j + 1]
	jnc		sort_3
	st		r5, [r0, r3]	;	array[j] = array[j + 1]
	inc		r3
	st		r4, [r0, r3]	;	array[j + 1] = array[j]
	dec		r3
sort_3:
	inc		r3				;	++j
	jmp		sort_4
sort_2:
	inc		r2				;	++i
	jmp		sort_5
sort_1:	
	ld		r2, sort_r2
	ld		r3, sort_r3
	ld		pc, sort_r5

	.end
/*						r0			r1		r2
int sorted_search( int arr[], int n_el, int val ) {
	int i; r3
	for( i = 0 ; i != n_el && arr[i] < val ; ++i )
		;
	if( i == n_el || arr[i] != val )
		return -i;
	return i;
}
*/

	.data
	
sorted_search:
	ldi	r3, #0
for:
	sub	r6, r3, r1
	jz	L1
	ld	r4, [r0, r3]
	sub	r6, r4, r2
	jnc	L1
	inc	r3
	jmp for
L1:
	sub r6, r3, r1
	jz	L2
	ld	r4, [r0, r3]
	sub	r6, r4, r2
	jnz	L2
	not	r0, r3
	inc	r0
	ret
L2:
	mov	r0, r3
	ret

/*
void copy_block( byte dst[], byte src[], int size );
					r0			r1			r2

*/
	.data
	copy_block_r5:	.word
	
copy_block:

	sub	r2, r2, #0
	jz	L1
	sub	r2, r2, #1
	sub	r6, r0, r1
	jnc	L2

/* endereço DST menor que SRC - começa dos endereços menores */

	ldb r3, [r1, #0]
	stb	r3, [r0, #0]
	inc	r1
	inc	r0
	dec r2
	jnz	L4
	ret

	/* endereço DST maior que SRC - começa dos endereços maiores */
L2:
	ldb	r3, [r1, r2]
	stb r3, [r0, r2]
	dec r2
	jnz	L2

L1:
	ret
	.section startup
	.org	0

	jmp	main

	.data
aw:	.word	2345
bw:	.word	6789
cw:	.word

ab:	.word	0xaa
bb:	.word	0xbb
cb:	.word

	.text
main:
	ld		r0, aw
	ld		r1, bw
	jmpl	sum
	st		r0, cw

	ldb		r0, ab
	ldb		r1, bb
	jmpl	sum
	stb		r0, cb

sum:
	add		r0, r0, r1
	ret

	.end

	.text
	.org	0
	ldi		r4, #00
	ldih	r4, #0xff
	ldi		r0, #00
	sub		r1, r0, #1
loop:
	st		r0, [r4, #0]
	st		r1, [r4, #0]
	jmp		loop
	.end	.text
	.org	0
	ldi		r4, #00
	ldih	r4, #0xff
loop:
	ld		r0, [r4, #0]
	st		r0, [r4, #0]
	jmp		loop
	.end
	/*
void main() {
	keyboard_init();
	ir_init();
	while ( 1 ) {
		byte key = keyboard_transition_wait();
		ir_transmit(key);
	}
}

void ir_transmit(byte n) {
	for ( ; n > 0; --n) {
		while (input_osc() == 0)
			;
		output_signal(1);
		while (input_osc() == 1)
			;
		output_signal(0);
	}
}
*/
/*
byte key = keyboard_transition_wait() {
	while (input_keyboard() != 0xf)
		;
	while (1)
		for (r = 0, r_mask = 1; r < MAX_R; ++r, r_mask <<= 1) {
			output_keyboard(~r_mask);
			col = input_keyboard();
			for (c = 0, c_mask = 1; c < MAX_C; ++c, c_mask <<= 1)
				if ((col & c_mask) == 0)
					return decoder(r, c);
		}
}
*/


keyboard_transition_wait:
	st	r1, keyboard_transition_wait_r1
	st	r2, keyboard_transition_wait_r2
	st	r3, keyboard_transition_wait_r3
	st	r4, keyboard_transition_wait_r4
	st	r5, keyboard_transition_wait_r5
	
	ldi	r0, #0
	jmpl	output_keyboard
	ldi	r1, #0xf
keyboard_transition_wait1:			; while (input...
	jmpl	input_keyboard
	sub	r6, r0, r1
	jz	keyboard_transition_wait1
keyboard_transition_wait2:			; while (1)
	ldi	r4, #0				; for (r = 0,
	ldi	r3, #1				; r_mask = 1;
keyboard_transition_wait3:			; r < MAX_R;
	sub	r6, r4, #MAX_R
	jnc	keyboard_transition_wait2
	
	mov	r0, r3
	not	r0, r0
	jmpl	output_keyboard			; output_keyboard(~r_mask);
	jmpl	input_keyboard			; col = input_keyboard();

	ldi	r1, #0				; for(c = 0,
	ldi	r2, #1				; c_mask = 1;
keyboard_transition_wait6:
	sub	r6, r1, #MAX_C			; c < MAX_C
	jnc	keyboard_transition_wait5
	anl	r6, r0, r2			; if ((col & c_mask)
	jnz	keyboard_transition_wait4
	mov	r0, r4
	jmpl	decoder				; return decoder(r, c)

	ld	r1, keyboard_transition_wait_r1
	ld	r2, keyboard_transition_wait_r2
	ld	r3, keyboard_transition_wait_r3
	ld	r4, keyboard_transition_wait_r4
	ld	pc, keyboard_transition_wait_r5

keyboard_transition_wait4:
	inc	r1
	shl	r2, r2, #1, 0
	jmp	keyboard_transition_wait6
	
keyboard_transition_wait5:
	inc	r4
	shl	r3, r3, #1, 0
	jmp	keyboard_transition_wait3
	
/*------------------------------------------------------------------------------
*/
isr_keyboard:
	st	r0, isr_keyboard_r0
	st	r5, isr_keyboard_r0

	ldi	r4, #0				; for (r = 0,
	ldi	r3, #1				; r_mask = 1;
isr_keyboard2:					; r < MAX_R;
	sub	r6, r4, #MAX_R
	jnc	isr_keyboard1
	
	mov	r0, r3
	not	r0, r0
	jmpl	output_keyboard			; output_keyboard(~r_mask);
	jmpl	input_keyboard			; col = input_keyboard();

	ldi	r1, #0				; for(c = 0,
	ldi	r2, #1				; c_mask = 1;
isr_keyboard3:
	sub	r6, r1, #MAX_C			; c < MAX_C
	jnc	isr_keyboard5
	anl	r6, r0, r2			; if ((col & c_mask)
	jnz	isr_keyboard4
	mov	r0, r4
	jmpl	decoder				; decoder(r, c)

	jmpl	circbuffer_push
	jmp	isr_keyboard1
	
isr_keyboard4:
	inc	r1				; ++c
	shl	r2, r2, #1, 0			; c_mask <<= 1
	jmp	isr_keyboard3
	
isr_keyboard5:
	inc	r4				; ++r
	shl	r3, r3, #1, 0			; r_mask <<= 1
	jmp	isr_keyboard2

isr_keyboard1:
	jmpl	output_clear_interrupt
	ld	r0, isr_keyboard_r0
	ld	r5, isr_keyboard_r5
	iret

keyboard_transition_wait:
	jmpl	circbuffer_pop
	ret
	.org 0
	jmp	main
	jmp isr


	.data
	
	.text

	main:
	
main1:
	jmpl	keyboard_transition_wait
	jmpl	ir_transmit
	jmp		main1
	
	
ir_transmit:
	ldb	r1, first
	add	r1, r0, #0
	jz	ir_transmit1
	ldi	r1, #1
	stb r1, first
	ld	r1, timer_address
	stb r0, [r1, #1]
	ret
ir_transmit1:
	ldi	r6, #0xef	; disable interrupts
	jmpl	buffercirc_push
	ldi	r6, #0x10	; enable interrupts
	ret

	.data
isr_r0:	.word

isr:
	stb	r0, isr_r0
	jmpl	buffercirc_pop
	ld	r1, timer_address
	stb	r0, [r1, #1]
	jmpl	buffercirc_empty
	add	r0, r0, #0
	ldb	r0, isr_r0
	jnz	isr1
	ldi	r1, #0xef
	anl	r0, r0, r1	; disable interrupts
isr1:
	iret
	.section startup
	.org	0
	jmp	main

	.data

timer_address:	.word	0xff41
input_port_address:	.word	0xff01

	.text

ir_transmit:
	ld	r1, input_port_address
ir_transmit1:
	ldb	r2, [r1, #0]
	shr	r2, r2, #1, 0
	jnc	ir_transmit1

	ld	r1, timer_address
	stb	r0, [r1, #2]

	ld	r1, input_port_address
ir_transmit2:
	ldb	r2, [r1, #0]
	shr	r2, r2, #1, 0
	jc	ir_transmit2
	ret

	
	
main:
	ldi	r0, #1
	ld	r1, timer_address
	stb	r0, [r1, #0]
main1:
	ldi	r0, #3
	jmpl	ir_transmit
	ldi	r0, #2
	jmpl	ir_transmit
	jmp	main1

	.end
	.section	startup
	.org		0
	jmp			main

/* -----------------------------------------------------------------------------------------------------------
	Programa principal
*/
	.text
main:
/* =================================== iniciações */
	jmpl 	lcd_init
	ldi		r0, #'a'
	jmpl	lcd_write_char
	jmp 	$

/*-----------------------------------------------------------------------------
	Display
*/
	.data
/*
				R/nW	RS		
				A2		A1		A0
WRITE_CONTROL	0		0		1
WRITE_DATA		0		1		1
READ_CONTROL	1		0		1
READ_DATA		1		1		1
*/

lcd_write_control:
	.word	0xFF40		/*	0 0 1	*/
lcd_write_data:
	.word	0xFF42		/*	0 1 1	*/
lcd_read_control:
	.word	0xFF44		/*	1 0 1	*/
lcd_read_data:
	.word	0xFF46		/*	1 1 1	*/

lcd_write_string_r5:
	.word

	.text
/* void lcd_init()
*/

lcd_init:
	ldi		r0, #0x30
	ld		r1, lcd_write_control
	stb		r0, [r1, #1]
	stb		r0, [r1, #1]
	stb		r0, [r1, #1]
	ldi		r0, #0x38
	stb		r0, [r1, #1]
	ldi		r0, #0x08
	stb		r0, [r1, #1]
	ldi		r0, #0x01
	stb		r0, [r1, #1]
	ldi		r0, #0x06
	stb		r0, [r1, #1]
	ldi		r0, #0x0c
	stb		r0, [r1, #1]
	ret

/*	void lcd_write_char(char c)
*/

lcd_write_char:
	ld		r1, lcd_write_data
	stb		r0, [r1, #1]
	ret

/* 	void lcd_write_string(char string[])
*/
lcd_write_string:
	ld		r1, lcd_write_data
	ldb		r2, [r0, #0]
;	mov		r2, r2				/* como nunca é chamada com string vazia, não é preciso testar
;	jz		lws2
lws1:
	stb		r2, [r1, #1]
	inc		r0
	ldb		r2, [r0, #0]
	mov		r2, r2
	jnz		lws1
lws2:
	ret

/* 	void lcd_write_chars(char string[], int n)
*/
lcd_write_chars:
	mov		r1, r1
	jz		lwc2
	ld		r3, lcd_write_data
lwc1:
	ldb		r2, [r0, #0]
	stb		r2, [r3, #1]
	inc		r0
	dec		r1
	jnz		lwc1
lwc2:
	ret

/* 	void lcd_set_cursor_position(int c, int l)
	1 ADD ADD ADD ADD ADD ADD ADD
	
	ADD = l * 64 + c
*/
lcd_set_cursor_position:
	shl		r1, r1, #6, 0	
	add		r0, r0, r1		/* r0 = l * 64 + c */
	ldi		r1, #0x80
	orl		r0, r0, r1
	ld		r1, lcd_write_control
	stb		r0, [r1, #1]
	ret

	.end
	.section	startup
	.org		0
	jmp			main


	.data
output_port_address:
	.word	0xff00
input_port_address:
	.word	0xff00
output_port_image:
	.byte
	
column:			/* hora e minuto de despertar */
	.byte	0

/* -----------------------------------------------------------------------------------------------------------
	Programa principal
*/
	.text
main:
/* =================================== iniciações */
	jmpl 	lcd_init
	jmpl 	button_init

/* =================================== ciclo do programa principal */


/* ----------------------- atualizar o display */
main1:
/*	jmpl	lcd_clear	*/

							/* afixar a referencia na linha 1, coluna <column> */
/*	ld		r0, column
	ldi		r1, #1
	jmpl	lcd_set_cursor_position
*/
	ldi		r0, #'|'
	jmpl	lcd_write_char

/* -------------------------verificar se há botão premido */
main2:
	jmpl 	button_read
	sub		r6, r0, #3
	jz		main1
	ldi		r5, #low(process_button)
	ldih	r5, #high(process_button)
	jmpl 	r5, #0
	jmp		main1

/* -----------------------------------------------------------------------------------------------------------
	Botões
*/
	.data
button_previous:
	.byte
button_mask:
	.byte	7

	.text
/* 
	button_init();
*/

button_init:
	ldb	r0, button_mask
	stb	r0, button_previous
	ret

/* 
	int button_read();
*/

button_read:
	ld		r0, input_port_address
	ldb		r0, [r0, #1]			/* ler estado dos botões */
	ldb		r1, button_mask			/* pôr a zero bits que não interessam */
	anl		r0, r0, r1
;	ldb		r2, button_previous		
;	stb		r0, button_previous
;	xrl		r6, r2, r1				/* por simplicidade, retorna já se o estado anterior tiver alguma tecla premida */
;	jz		bgs1
;	ldi		r0, #3					/* saída sem deteção de transição positiva */
;	ret

bgs1:
	ldi		r2, #0					/* r2 - posição do bit em teste */
	shr		r0, r0, #1, 0
	jnc		bgs2					/* sai se for 0 */
bgs3:
	inc		r2
	shr		r0, r0, #1, 0			/* deslocar para o próximo bit */
	jc		bgs3					/* permanece enquanto for 1 */
bgs2:
	mov		r0, r2
	ret

/*-----------------------------------------------------------------------------
	Display
*/
	.data
/*
				R/nW	RS		
				A2		A1		A0
WRITE_CONTROL	0		0		1
WRITE_DATA		0		1		1
READ_CONTROL	1		0		1
READ_DATA		1		1		1
*/

lcd_write_control:
	.word	0xFF40		/*	0 0 1	*/
lcd_write_data:
	.word	0xFF42		/*	0 1 1	*/
lcd_read_control:
	.word	0xFF44		/*	1 0 1	*/
lcd_read_data:
	.word	0xFF46		/*	1 1 1	*/

lcd_write_string_r5:
	.word

	.text
/* void lcd_init()
*/

lcd_init:
	ldi		r0, #0x30
	ld		r1, lcd_write_control
	stb		r0, [r1, #1]
	stb		r0, [r1, #1]
	stb		r0, [r1, #1]
	ldi		r0, #0x38
	stb		r0, [r1, #1]
	ldi		r0, #0x08
	stb		r0, [r1, #1]
	ldi		r0, #0x01
	stb		r0, [r1, #1]
	ldi		r0, #0x06
	stb		r0, [r1, #1]
	ldi		r0, #0x0c
	stb		r0, [r1, #1]
	ldi		r0, #0x18
	stb		r0, [r1, #1]
	ret

/*	void lcd_write_char(char c)
*/

lcd_write_char:
	ld		r1, lcd_write_data
	stb		r0, [r1, #1]
	ret

/* 	void lcd_write_string(char string[])
*/
lcd_write_string:
	ld		r1, lcd_write_data
	ldb		r2, [r0, #0]
;	mov		r2, r2				/* como nunca é chamada com string vazia, não é preciso testar
;	jz		lws2
lws1:
	stb		r2, [r1, #1]
	inc		r0
	ldb		r2, [r0, #0]
	mov		r2, r2
	jnz		lws1
lws2:
	ret

/* 	void lcd_write_chars(char string[], int n)
*/
lcd_write_chars:
	mov		r1, r1
	jz		lwc2
	ld		r3, lcd_write_data
lwc1:
	ldb		r2, [r0, #0]
	stb		r2, [r3, #1]
	inc		r0
	dec		r1
	jnz		lwc1
lwc2:
	ret

/* 	void lcd_set_cursor_position(int c, int l)
	1 ADD ADD ADD ADD ADD ADD ADD
	
	ADD = l * 64 + c
*/
lcd_set_cursor_position:
	shl		r1, r1, #6, 0	
	add		r0, r0, r1		/* r0 = l * 64 + c */
	ldi		r1, #0x80
	orl		r0, r0, r1
	ld		r1, lcd_write_control
	stb		r0, [r1, #1]
	ret

/*	void lcd_clear()
*/
lcd_clear:
	ldi		r0, #1
	ld		r1, lcd_write_control
	stb		r0, [r1, #1]
	ret
	
/* 	void lcd_clear_line(int y)
*/

/* -----------------------------------------------------------------------------------------------------------
	Processar botão; depende do estado de acerto
*/
	.data
b_r5:
	.word

	.text

process_button:
	st		r5, b_r5

	sub		r6, r0, #2					/* Tecla Up ? */
	jnz		pb1
	ldb		r0, column
	add		r0, r0, #1
	ldi		r1, #16
	sub 	r6, r0, r1
	jnz		pb3
	sub		r0, r0, #1
pb3:
	stb		r0, column
	jmp		pb2
pb1:
	sub		r6, r0, #1					/* Tecla Down ? */
	jnz		pb2
	ldb		r0, column
	sub		r0, r0, #1 
	jnc		pb4
	add		r0, r0, #1
pb4:
	stb		r0, column
pb2:
	ld		pc, b_r5

	.end



/* variaveis inicializadas */
.section directData
.org 10
var4x12:
.byte low(40*3+14/2) , high(255 + 0x101), 12, 13, 14, 32, 98, 255 ; decimal
.byte 014 ;octal
.byte 0xC ;hexadecimal
.byte -12 ; negativos -> -número
; .byte 1100b ;binario

.section indirectData
varChar:
	.byte	'A', 'B', 'C',0x0a,0x0d,0
/* vários bytes com os códigos ascii das letras */
varWord:
	.word	0xA25C ; dois bytes
varWord:
	.word	main, l1, rotina	; inicia array com os endereços das várias referências
varArray:
	.space 5, 0xAB ;preenche 5 bytes com o valor 0xAB
	.space 3	;reserva 3 bytes e inicia com zero
varTexto:
	.ascii "isto é texto que não acaba com um byte a zero"
	.ascii "isto é", " texto que" , " não acaba com um byte a zero"
	/* código */
	.section start
	.org 0
	ld	r7,[r7,#1]
	jmp	isr
	.word	main
	/* utilizam-se as mesmas primitivas que em .data ou as seguintes */
	.equ	const1, 86
	.set	const2, 10
	.word	0xA25C /* dois bytes */
	.space	3, 0xAB

	.section main
	.org 0x2000
main:
	ldi R0,#123
	ld r1,[r7,#1]	; jmp main
	jmp	l1
	.word	main
l1:	
	ldi R2,#low(varArray)
	ldih	R3,#high(varArray)
	jmpl	rotina
	jmp	$
	
rotina:
	st	R0,[r2,#0]
	ld	r0,[r1,#4]
	ld	r3,var4x12+4
	movf	r0,r2
	inc	r2
	ret
/* fim do modulo */
.end
