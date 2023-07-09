%{
    #include <stdio.h>
    #include <stdlib.h>
    int yylex(void);
    void yyerror(char *);
    extern int yylineno, yycolno;
    extern char* yytext;
%}

/* tipos primitivos */
%token INTEIRO LOGICO
%token VERDADEIRO FALSO
/* entrada e saída */
%token LER ESCREVER
/* estruturas de repetição */
%token ENQUANTO FACA
/* estruturas condicionais */
%token SE ENTAO SENAO
/* operadores aritméticos */
%token SOMA SUBTRACAO MULTIPLICACAO DIVISAO
/* operadores relacionais */
%token IGUAL DIFERENTE MENOR MENOR_OU_IGUAL MAIOR MAIOR_OU_IGUAL
/* atribuições */
%token ATRIBUICAO
/* declaração de variáveis */
%token DECLARACAO
/* delimitadores */
%token PROGRAMA INICIO FIM
%token PONTO_E_VIRGULA VIRGULA DOIS_PONTOS ABRE_PARENTESES FECHA_PARENTESES
/* tokens variáveis (que precisam de uma tabela auxiliar) */
%token IDENTIFICADOR STRING NUMERO

/*
    Garante a precedência dos operadores aritméticos 
    Obs: a gramática já garante, porém, é um bom sanity check
*/
%left SOMA SUBTRACAO
%left MULTIPLICACAO DIVISAO

%start s

%%

/* Gramática que define a Linguagem */
s:      PROGRAMA IDENTIFICADOR PONTO_E_VIRGULA s1
        ;
s1:     d m
        | m
        ;
d:      DECLARACAO v
        ;
v:      i DOIS_PONTOS t PONTO_E_VIRGULA v1
        ;
v1:     v
        |
        ;
t:      INTEIRO
        | LOGICO
        ;
i:      IDENTIFICADOR i1
        ;
i1:     VIRGULA i
        |
        ;
l:      n PONTO_E_VIRGULA l1
        ;
l1:     l
        |
        ;
c:      IDENTIFICADOR ATRIBUICAO a
        | LER r
        | ESCREVER w
        | m
        | ENQUANTO ABRE_PARENTESES b FECHA_PARENTESES FACA n
        ;
a:      e
        | VERDADEIRO
        | FALSO
        ;
r:      ABRE_PARENTESES i FECHA_PARENTESES
        |
        ;
w:      ABRE_PARENTESES f FECHA_PARENTESES
        |
        ;
f:      g f1
        ;
f1:     VIRGULA f
        |
        ;
g:      STRING
        | e
        ;
m:      INICIO m1
        ;
m1:     l FIM
        ;
n:      SE b ENTAO n1
        | c
        ;
n1:     n 
        | SENAO n
        ;
e:      x e1
        ;
e1:     SOMA x e1
        | SUBTRACAO x e1
        |
        ;
x:      y x1
        ;
x1:     MULTIPLICACAO y x1
        | DIVISAO y x1
        |
        ;
y:      SUBTRACAO k
        | k
        ;
k:      ABRE_PARENTESES e FECHA_PARENTESES
        | IDENTIFICADOR
        | NUMERO
        ;
b:      e b1
        ;
b1:     IGUAL e
        | MENOR e
        | DIFERENTE e
        | MENOR_OU_IGUAL e
        | MAIOR e
        | MAIOR_OU_IGUAL e
        |
        ;
%%

void yyerror(char* s) {
    fprintf(stderr, "[%s] Linha [%d] Coluna [%d] Token [%s]\n", s, yylineno, yycolno, yytext);
}

int main() {
    yyparse();
    return EXIT_SUCCESS;
}