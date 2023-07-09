%{
    #include <stdio.h>
    #include <stdlib.h>
    // int yylex(void);
    void yyerror(char *);
%}

// tipos primitivos
%token INTEIRO
%token LOGICO
// entrada e saída
%token LER
%token ESCREVER
// estruturas de repetição
%token ENQUANTO
%token FACA
// estruturas condicionais
%token SE
%token ENTAO
%token SENAO
// operadores aritméticos
%token SOMA
%token SUBTRACAO
%token MULTIPLICACAO
%token DIVISAO
// operadores relacionais
%token IGUAL
%token DIFERENTE
%token MENOR
%token MENOR_OU_IGUAL
%token MAIOR
%token MAIOR_OU_IGUAL
// comentários
%token COMENTARIO
// atribuições
%token ATRIBUICAO
// declaração de variáveis
%token DECLARACAO
// delimitadores
%token PROGRAMA
%token INICIO
%token FIM
%token PONTO_E_VIRGULA
%token VIRGULA
%token DOIS_PONTOS
%token ABRE_PARENTESES
%token FECHA_PARENTESES

// tokens variáveis (que precisam de uma tabela auxiliar)
%token IDENTIFICADOR
%token STRING
%token NUMERO

%%

s: IDENTIFICADOR

%%

void yyerror(char* s) {
    fprintf(stderr, "%s\n", s);
}

int main() {
    yyparse();
    return EXIT_SUCCESS;
}