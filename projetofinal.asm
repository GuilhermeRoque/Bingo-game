ORG 0000h
jmp condicaoinicial


ORG 0003h
call interrupcao0
reti


condicaoinicial:
;p3.2 interrupcao 0 aciona buzzer aciona led  inicia contagem do jogo
;p3.1 led verde
;p3.5 buzzerinicial
	mov p0,#00h;display de minutos
	mov p1,#00h;display dezenas sorteadas
	mov p2,#00h;display de segundos
	MOV P3,#00000100B; INT0 na P3.2 - buzzer na P3.4 - LED vermelho na p3.0 - verde na p3.1

	mov r0,#00h ;monitora dezenas sorteadas
	mov r2,#00h;monitora os lsb dos displays de segundos
	mov r3,#00h;monitora os lsb dos displays de minutos
	mov r1,#00h
	mov r4,#00h
	mov r5,#00h
	mov r6,#00h
	mov r7,#00h

	mov dptr,#0600h
	mov ie,#10000001b
	setb px0


;------------------------------------------------------------------------------------------------
interrupcao0:
	CLR TR0
	JNB P3.1,COMECA
	call ledezenasorteada
	SETB TR0
	RET

;------------------------------------------------------------------------------------------------

inicio:
	JNB P3.1,INICIO
	call contatempo
	jmp $

;------------------------------------------------------------------------------------------------
COMECA:
	call apitabuzeerinicial
	setb p3.1 ;liga led verde
	call ledezenasorteada
	RET
	
;------------------------------------------------------------------------------------------------
contaSegundo:
	setb tr0
loop:
	jnb tf0, loop
   	inc r1
   	clr tr0
   	clr tf0
   	cjne r1, #122d, contasegundo
   	mov r1,#00h
   	ret

;------------------------------------------------------------------------------------------------

apitabuzeerinicial: ;liga buzzer por 2 segundos
	setb p3.5
	call contasegundo
	call contasegundo
	clr p3.5
	ret
;------------------------------------------------------------------------------------------------

contatempo:
	call contasegundo
	call incrementadisplaysegundo
	cjne r2,#9d,contatempo
	call contasegundo
	mov a,p2
	call adicionadezena
	cjne a,#60h,dezenasegundo;nao completou 1 minuto passa pra proxima dezena dos segundos
	;completou 1 minuto ->logica dos minutos:
	call limpasegundos
	call incrementadisplayminuto
	cjne r3,#9d,contatempo
	mov a,p0
	call adicionadezena
	mov p0,a
	mov r3,#00h
	jmp contatempo
dezenasegundo:
	mov p2,a
	mov r2, #00h
	jmp contatempo


;------------------------------------------------------------------------------------------------

ledezenasorteada:
	mov a,r0
	movc a,@a+dptr
	mov r4,a
volta:
	inc r5
	inc r6
	djnz r4,continua
	jmp retorna
continua:
	cjne r6,#9d,volta
	mov a,r5
	subb a,#9d
	add a,#00010000b
	mov r5,a
	mov r6,#00h
	djnz r4,volta
retorna:
	mov p1,r5
	inc r0
	mov r5,#00h
	mov r6,#00h
	ret

limpasegundos:
	mov p2,#00h
	mov r2, #00h
	ret
adicionadezena:
	subb a,#9d ;quando os LSB chegar a 9 os mesmos serão limpados para incremento da dezena
	add a,#00010000b ;será incrementado 1b nos MSB
	ret
incrementadisplaysegundo:
	inc p2 ;incrementa o display de segundos
	inc r2
	ret
incrementadisplayminuto:
	inc r3
	inc p0
	ret
;------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------

ORG 0600h
	 DB 25d
	 DB 08d
	 DB 33d
	 DB 09d
	 DB 38d
	 DB 75d
	 DB 50d
	 DB 16d
	 DB 34d
	 DB 66d
	 DB 28d
	 DB 56d
	 DB 71d
	 DB 47d
	 DB 53d
	 DB 90d
	 DB 58d
	 DB 27d
	 DB 02d
	 DB 31d
	 DB 18d
	 DB 07d
	 DB 01d
	 DB 60d
	 DB 11d
	 DB 54d
	 DB 87d
	 DB 76d
	 DB 74d
	 DB 63d
	 DB 26d
	 DB 96d
	 DB 72d
	 DB 69d
	 DB 23d
	 DB 55d
	 DB 83d
	end



