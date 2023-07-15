; Jogo da Velha

;PROCESSO DO PROGRAMA:
;1 - entra no menu
;2 - imprimi o tabuleiro
;3 - le a entrada do usuario
;4 - calcula se e uma possivel Pontuacao
;5 - soma 1 na pontuacao do jogador vitorioso
;6 - volta a imprimir o tabuleiro

jmp main

string_empate: string "EMPATE"
x_vencedor: string "X VENCEU"
o_vencedor: string "O VENCEU"

entrada_menu_nome : string "JOGO DA VELHA !"
entrada_menu_botao : string "Pressione Enter"
entrada_menu_aluno1 : string "BRENO GONCALVES RODRIGUES"
entrada_menu_aluno2 : string "HENRIQUE SOUZA MARQUES"
entrada_menu_aluno3 : string "CHRISTIAN SIMAS GIOIA"

X: string "X"
O: string "O"

; cada linha do simulador tem +- 40 caracteres

;---- Inicio do Programa Principal -----
main:
	jmp imprime_menu
	
imprime_string:		;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0			; protege o r0 na pilha para preservar seu valor
	push r1			; protege o r1 na pilha para preservar seu valor
	push r2			; protege o r1 na pilha para preservar seu valor
	push r3			; protege o r3 na pilha para ser usado na subrotina
	push r4			; protege o r4 na pilha para ser usado na subrotina
	
	loadn r3, #'\0'	; Criterio de parada

imprime_string_Loop:	
	loadi r4, r1
	cmp r4, r3
	jeq imprime_string_Sai
	add r4, r2, r4
	outchar r4, r0
	inc r0
	inc r1
	jmp imprime_string_Loop
	
imprime_string_Sai:	
	pop r4			; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts

; imprime o menu do jogo
imprime_menu:
	loadn r0, #213				
	loadn r1, #entrada_menu_nome	
	loadn r2, #256					
	call imprime_string
	
	loadn r0, #613				
	loadn r1, #entrada_menu_botao	
	loadn r2, #256					
	call imprime_string
	
	loadn r0, #1007				
	loadn r1, #entrada_menu_aluno1	
	loadn r2, #256					
	call imprime_string
	
	loadn r0, #1088				
	loadn r1, #entrada_menu_aluno2	
	loadn r2, #256					
	call imprime_string
	
	loadn r0, #1169			
	loadn r1, #entrada_menu_aluno3	
	loadn r2, #256
	call imprime_string
	
	loadn r2, #13 	; corresponde ao enter
	inchar r1 		; Le teclado
	cmp r1, r2
	jeq apaga
	jmp main
	
apaga:
	call ApagaTela
	jmp imprime_tabela

; zera a tela e apaga todas as strings que haviam nela
ApagaTela:
	push r0
	push r1
	
	loadn r4, #0
	loadn r0, #1200		; apaga as 1200 posicoes da Tela
	loadn r1, #' '		; com "espaco"
	
	ApagaTela_Loop:	;label for(r0=1200;r3>0;r3--)
		dec r0
		cmp r4, r0
		outchar r1, r0
		jne ApagaTela_Loop
 	
	pop r1
	pop r0
	rts

; imprime o tabuleiro
imprime_tabela:
	loadn r0, #0				
	loadn r1, #TABULEIRO	
	loadn r2, #0					
	call imprime_string

; iniciando o jogo com o x
iniciar_jogo:					
	call jogada_X					

; imprime X
vez_X:
	loadn r0, #50
	loadn r1, #X	
	loadn r2, #256			
	
	call imprime_string
	
	rts

; imprime O
vez_O:
	loadn r0, #50
	loadn r1, #O
	loadn r2, #3072					
	
	call imprime_string
	
	rts

; coloca o x no tabuleiro
jogada_X:
	
	loadn r2, #9
	loadn r4, #CONTADOR
	loadi r5, r4
	cmp r5, r2
	jeq empate
	
	; somando a quantidade de jogadas (max 9)
	loadn r0, #1
	loadi r2, r4
	add r2, r2, r0
	storei r4, r2
	
	call vez_X
		
	leitura_X:
		loadn r6, #255						; condicao de loop (aguardando a entrada do usuario)
		loadn r3, #49 						; o ASCII 1 do 1 é #49 (precisamos subtrair esse valor da entrada para pegar a posicao correta do vetor de coordenadas)
				
		inchar r7							; leitura do teclado
		cmp r7, r6							; se o usuario digitou alguma coisa saimos do loop
		jeq leitura_X
	
	loadn r4, #POSICAO_PARA_COORDENADA	; carrega o vetor de coordenadas (BASE)
	
	sub r1, r7, r3						; r1 é o OFFSET do vetor de coordenadas				
	mov r6, r1							; precisamos salvar o OFFSET para depois avaliar se podemos escrever nessa posicao
	add r4, r4, r1						; indo para a posicao correta do vetor (BASE + OFFSET)
	
	; imprime string precisa de: POSICAO DA TELA, STRING, COR
	loadi  r0, r4						; carregando da memoria ( MEM [BASE + OFFSET] ) -> POSICAO DA TELA
	loadn r1, #X						; carregando da memoria a string "X" -> STRING
	loadn r2, #256						; carregando a cor -> COR
		
	; VERIFICANDO SE A POSICAO E VALIDA (AINDA NAO TEM "O" NEM "X")
	loadn r3, #POSICAO_PREENCHIDAS 	; vetor para verificacao se a posicao digitada pelo usuario ja possui alguma coisa
	add r3, r3, r6					; indo para a posicao correta do vetor (BASE + OFFSET)
	mov r6, r3						; precisamos salvar o OFFSET para depois atualizar essa posicao com o "X" (codigo 1)
	loadi  r3, r3
						
	loadn r5, #0
	cmp r3, r5						; se o vetor nessa posicao esta guardando zero, ou seja, nao tem nem "O" nem "X", jump para a "posicao_valida_o"
	
	jeq posicao_valida_x 
						
	jmp leitura_X					; caso contrario voltamos para ler uma nova posicao
	
; imprime bolinha
jogada_O:
	
	loadn r2, #9
	loadn r4, #CONTADOR
	loadi r5, r4
	cmp r5, r2
	jeq empate
	
	; somando a quantidade de jogadas (max 9) 
	loadn r0, #1
	loadi r2, r4
	add r2, r2, r0
	storei r4, r2
	
	call vez_O
	
	leitura_O:
		loadn r6, #255						; condicao de loop (aguardando a entrada do usuario)
		loadn r3, #49 						; o ASCII 1 do 1 é #49 (precisamos subtrair esse valor da entrada para pegar a posicao correta do vetor de coordenadas)
	
		
		inchar r7							; leitura do teclado
		cmp r7, r6							; se o usuario digitou alguma coisa saimos do loop
		jeq leitura_O
	
	loadn r4, #POSICAO_PARA_COORDENADA	; carrega o vetor de coordenadas (BASE)
	
	sub r1, r7, r3						; r1 é o OFFSET do vetor de coordenadas				
	mov r6, r1							; precisamos salvar o OFFSET para depois avaliar se podemos escrever nessa posicao
	add r4, r4, r1						; indo para a posicao correta do vetor (BASE + OFFSET)
	
	; imprime string precisa de: POSICAO DA TELA, STRING, COR
	loadi  r0, r4						; carregando da memoria ( MEM [BASE + OFFSET] ) -> POSICAO DA TELA
	loadn r1, #O						; carregando da memoria a string "X" -> STRING
	loadn r2, #3072						; carregando a cor -> COR		
	
	; VERIFICANDO SE A POSICAO E VALIDA (AINDA NAO TEM "O" NEM "X")
	loadn r3, #POSICAO_PREENCHIDAS 	; vetor para verificacao se a posicao digitada pelo usuario ja possui alguma coisa
	add r3, r3, r6					; indo para a posicao correta do vetor (BASE + OFFSET)
	mov r6, r3						; precisamos salvar o OFFSET para depois atualizar essa posicao com o "O" (codigo 2)
	loadi  r3, r3
						
	loadn r5, #0
	cmp r3, r5						; se o vetor nessa posicao esta guardando zero, ou seja, nao tem nem "O" nem "X", jump para a "posicao_valida_o"
	
	jeq posicao_valida_o 
							
	jmp leitura_O					; caso contrario voltamos para ler uma nova posicao

; chegamos aqui se a posicao colocada pelo usuario for valida
posicao_valida_x:					
	call imprime_string 
	
	; salvando no conteudo da posicao digitada pelo usuario o codigo do "X" (codigo 1, ou seja, estamos salvando em memoria que aquela posicao ja esta ocupada por "X")
	loadn r7, #1
	storei r6, r7
	
	jmp checagem_vitoria_X
	
; chegamos aqui se a posicao colocada pelo usuario for valida
posicao_valida_o:
	call imprime_string
	
	; salvando no conteudo da posicao digitada pelo usuario o codigo do "O" (codigo 2, ou seja, estamos salvando em memoria que aquela posicao ja esta ocupada por "O")
	loadn r7, #2
	storei r6, r7
	
	jmp checagem_vitoria_O



checagem_vitoria_X:		
	loadn r6, #1
	jmp compara_linhas
	
	checa_colunas_x:
		jmp compara_colunas
	checa_diagonais_x:
		jmp compara_diagonais
					
checagem_vitoria_O:
	loadn r6, #2
	jmp compara_linhas

	checa_colunas_o:
		jmp compara_colunas
	checa_diagonais_o:
		jmp compara_diagonais
	
compara_linhas:
	
	loadn r4, #POSICAO_PREENCHIDAS

	loadi r5, r4						; verificando se o primeiro posicao da linha do tabuleiro e X
	cmp r5, r6							; compara se a primeira posicao do tabuleiro e igual a X
	jne compara_linha_2
	
	inc r4
	loadi r5, r4
	cmp r5, r6
	jne compara_linha_2
	
	inc r4
	loadi r5, r4
	cmp r5, r6
	jne compara_linha_2
	jmp vencedor

compara_linha_2:
	loadn r4, #POSICAO_PREENCHIDAS
	loadn r5, #3
	add r4, r4, r5
	
	loadi r5, r4						; verificando se o primeiro posicao da linha do tabuleiro e X
	cmp r5, r6							; compara se a primeira posicao do tabuleiro e igual a X
	jne compara_linha_3
	
	inc r4
	loadi r5, r4
	cmp r5, r6
	jne compara_linha_3
	
	inc r4
	loadi r5, r4
	cmp r5, r6
	jne compara_linha_3
	
	jmp vencedor
	
compara_linha_3:
	loadn r4, #POSICAO_PREENCHIDAS
	loadn r5, #6
	add r4, r4, r5

	loadi r5, r4						; verificando se o primeiro posicao da linha do tabuleiro e X
	cmp r5, r6							; compara se a primeira posicao do tabuleiro e igual a X
	jne checa_colunas
	
	inc r4
	loadi r5, r4
	cmp r5, r6
	jne checa_colunas
	
	inc r4
	loadi r5, r4
	cmp r5, r6
	jne checa_colunas
	jmp vencedor

checa_colunas:
	loadn r7, #1
	cmp r6, r7
	jeq checa_colunas_x
	jmp checa_colunas_o	

checa_diagonais:
	loadn r7, #1
	cmp r6, r7
	jeq checa_diagonais_x
	jmp checa_diagonais_o	

compara_colunas:
	loadn r4, #POSICAO_PREENCHIDAS

	loadi r5, r4						; verificando se o primeiro posicao da linha do tabuleiro e X
	cmp r5, r6							; compara se a primeira posicao do tabuleiro e igual a X
	jne compara_coluna_2
	
	loadn r3, #3
	add r4, r4, r3
	loadi r5, r4
	cmp r5, r6
	jne compara_coluna_2
	
	add r4, r4, r3
	loadi r5, r4
	cmp r5, r6
	jne compara_coluna_2
	jmp vencedor

compara_coluna_2:
	loadn r4, #POSICAO_PREENCHIDAS
	loadn r5, #1
	add r4, r4, r5
	
	loadi r5, r4						; verificando se o primeiro posicao da linha do tabuleiro e X
	cmp r5, r6							; compara se a primeira posicao do tabuleiro e igual a X
	jne compara_coluna_3
	
	loadn r3, #3
	add r4, r4, r3
	loadi r5, r4
	cmp r5, r6
	jne compara_coluna_3
	
	add r4, r4, r3
	loadi r5, r4
	cmp r5, r6
	jne compara_coluna_3
	
	jmp vencedor

compara_coluna_3:
	loadn r4, #POSICAO_PREENCHIDAS
	loadn r5, #2
	add r4, r4, r5
	
	loadi r5, r4						; verificando se o primeiro posicao da linha do tabuleiro e X
	cmp r5, r6							; compara se a primeira posicao do tabuleiro e igual a X
	jne checa_diagonais
	
	loadn r3, #3
	add r4, r4, r3
	loadi r5, r4
	cmp r5, r6
	jne checa_diagonais
	
	add r4, r4, r3
	loadi r5, r4
	cmp r5, r6
	jne checa_diagonais
	
	jmp vencedor
	
compara_diagonais:
	loadn r4, #POSICAO_PREENCHIDAS

	loadi r5, r4						; verificando se o primeiro posicao da linha do tabuleiro e X
	cmp r5, r6							; compara se a primeira posicao do tabuleiro e igual a X
	jne compara_diagonal_2
	
	loadn r3, #4
	add r4, r4, r3
	loadi r5, r4
	cmp r5, r6
	jne compara_diagonal_2
	
	add r4, r4, r3
	loadi r5, r4
	cmp r5, r6
	jne compara_diagonal_2
	jmp vencedor

compara_diagonal_2:

	loadn r4, #POSICAO_PREENCHIDAS
	loadn r3, #2
	add r4, r4, r3
	
	loadi r5, r4						; verificando se o primeiro posicao da linha do tabuleiro e X
	cmp r5, r6							; compara se a primeira posicao do tabuleiro e igual a X
	jne imprime_proximo
	
	add r4, r4, r3
	loadi r5, r4
	cmp r5, r6
	jne imprime_proximo
	
	add r4, r4, r3
	loadi r5, r4
	cmp r5, r6
	jne imprime_proximo
	jmp vencedor
	
imprime_proximo:
	loadn r7, #1
	cmp r6, r7
	jeq jogada_O
	jmp jogada_X 


empate:
	call ApagaTela
	
	loadn r0, #617
	loadn r1, #string_empate	
	loadn r2, #256			
	call imprime_string
	halt


vencedor:
	loadn r5, #2
	cmp r6, r5
	jeq vencedor_o
	
vencedor_x:
	call ApagaTela
	
	loadn r0, #616
	loadn r1, #x_vencedor	
	loadn r2, #256			
	
	call imprime_string
	halt

vencedor_o:
	call ApagaTela

	loadn r0, #616
	loadn r1, #o_vencedor	
	loadn r2, #256			
	
	call imprime_string
	halt	

	

; contador de quantas jogadas foram realizadas
CONTADOR: var #1
static CONTADOR + #0, #0

POSICAO_PARA_COORDENADA : var #9
static POSICAO_PARA_COORDENADA + #0, #328
static POSICAO_PARA_COORDENADA + #1, #339
static POSICAO_PARA_COORDENADA + #2, #350
static POSICAO_PARA_COORDENADA + #3, #608
static POSICAO_PARA_COORDENADA + #4, #619
static POSICAO_PARA_COORDENADA + #5, #630
static POSICAO_PARA_COORDENADA + #6, #888
static POSICAO_PARA_COORDENADA + #7, #899
static POSICAO_PARA_COORDENADA + #8, #910

POSICAO_PREENCHIDAS : var #9
static POSICAO_PREENCHIDAS + #0, #0
static POSICAO_PREENCHIDAS + #1, #0
static POSICAO_PREENCHIDAS + #2, #0
static POSICAO_PREENCHIDAS + #3, #0
static POSICAO_PREENCHIDAS + #4, #0
static POSICAO_PREENCHIDAS + #5, #0
static POSICAO_PREENCHIDAS + #6, #0
static POSICAO_PREENCHIDAS + #7, #0
static POSICAO_PREENCHIDAS + #8, #0

TABULEIRO : string 
"
+-----------+                          
| Vez do    |                          
|           |                          
+-----------+                                                                 
             ||         ||             
             ||         ||             
             ||         ||             
        1    ||    2    ||    3        
             ||         ||             
             ||         ||             
    =========++=========++=========    
             ||         ||             
             ||         ||             
             ||         ||             
        4    ||    5    ||    6        
             ||         ||             
             ||         ||             
             ||         ||             
    =========++=========++=========    
             ||         ||             
             ||         ||             
        7    ||    8    ||    9        
             ||         ||             
             ||         ||             
             ||         ||             
"