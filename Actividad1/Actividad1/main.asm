;
; Actividad1.asm
;
; Created: 05/03/2026 11:29:20 a. m.
; Author : Angel Emiliano Rodriguez Cruz & Angel de Jesús Aguilar Andrade
;


; SEGMENTO DE DATOS (SRAM)
.dseg
.org SRAM_START

;reservar 100 bytes
table_of_unsorted_numbers:    .byte 100 
table_of_sorted_numbers_alg1: .byte 100 
table_of_sorted_numbers_alg2: .byte 100 

;Inicializar el stack
.cseg
.org 0x0
.def semilla = r17
.def multiplicador = r18

;init stack
	ldi r16, high(RAMEND)
	out SPH, r16
	ldi r16, low(RAMEND)
	out SPL, r1

;Main program
start:
	rcall gen_random_num
	rcall copy_to_bubble
	rcall organizar_bubble
	rjmp start

;Subrutina para generar numeros pseudoaleatorios
gen_random_num:
	;Apuntador
	ldi XH, high(table_of_unsorted_numbers)
	ldi XL, low(table_of_unsorted_numbers)

	;Preparar registros
	ldi r16, 0x64
	ldi semilla, 0x13	;Este valor se puede modificar para generar nuevos números pseudoaleatorios
	ldi multiplicador, 0x0D

;Genera numeros pseudoaletorios con la formula Xn+1=(a(Xn)+c)(mod m)
loop:
	mul semilla, multiplicador
	mov semilla, r0
	subi semilla, 0x07
	st X+, semilla
	dec r16
	brne loop
	ret

;Subrutina para copiar al espacio del bubble
copy_to_bubble:
	;Apuntador
	ldi XH, high(table_of_unsorted_numbers)
	ldi XL, low(table_of_unsorted_numbers)
	ldi YH, high(table_of_sorted_numbers_alg1)
	ldi YL, low(table_of_sorted_numbers_alg1)
	ldi r16, 0x64
loop_bubble:
	ld semilla, X+
	st Y+, semilla
	dec r16
	brne loop_bubble
	ret

;Organizar por el algoritmo bubble sort
organizar_bubble:
	ldi multiplicador, 0x64
bubble_loop_ext:
	;Apuntador
	ldi ZH, high(table_of_sorted_numbers_alg1)
	ldi ZL, low(table_of_sorted_numbers_alg1)
	mov r19, multiplicador
	dec r19
	breq fin_bubble
	clr r20
bubble_loop_int:
	ld r16, Z
	ldd semilla, Z+1
	cp r16, r17
	brlo saltar_intercambio
	st	Z, semilla
	std Z+1, r16
	ldi r20, 1
saltar_intercambio:
	adiw ZH:ZL, 1
	dec r19
	brne bubble_loop_int
	tst r20
	breq fin_bubble
	dec multiplicador
	brne bubble_loop_ext
fin_bubble:
	ret