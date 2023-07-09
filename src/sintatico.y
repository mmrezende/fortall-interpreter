%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdbool.h>
    int yylex(void);
    void yyerror(char *);
    void variavel_declara(char*, bool); // declara a variável e a coloca na tabela de variáveis
    bool variavel_acessa(char*); // acessa a variável e retorna verdadeiro se seu tipo for inteiro
    void variavel_verifica_tipo(char*, bool); // verifica o tipo da variável 
    extern int yylineno, yycolno;
    extern char* yytext;

    #include "edb.h"
    #include "tipos.h"
    #include "pilha.h"
    edb_t* tabela_variaveis;
    pilha_t* pilha_variaveis;
%}

%union
{
    char* stringVal;
    void* ptrVal;
    struct {
        int intVal;
        bool boolVal;
        bool ehInteiro;
    } expressao;
    bool boolVal;
}

/* tipos primitivos */
%token INTEIRO LOGICO
%token <expressao> VERDADEIRO FALSO
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
%token <stringVal> IDENTIFICADOR STRING
%token <expressao> NUMERO

/*
    Garante a precedência dos operadores aritméticos 
    Obs: a gramática já garante, porém, é um bom sanity check
*/
%left SOMA SUBTRACAO
%left MULTIPLICACAO DIVISAO

%start s

%type <ptrVal> i i1
%type <boolVal> t
%type <expressao> k y e a

%%

/* Gramática que define a linguagem */
s:      PROGRAMA IDENTIFICADOR PONTO_E_VIRGULA s1
        ;
s1:     d m 
        | m
        ;
d:      DECLARACAO v
        ;
v:      i DOIS_PONTOS t PONTO_E_VIRGULA v1 {
            while(!pilha_vazia($1)) {
                variavel_declara(pilha_remove($1), $3);
            }
            pilha_destroi($1);
        }
        ;
v1:     v
        |
        ;
t:      INTEIRO { $$ = true; }
        | LOGICO { $$ = false; }
        ;
i:      IDENTIFICADOR i1 {
            $$ = $2;
            pilha_insere($$, $1);
        }
        ;
i1:     VIRGULA i { $$ = $2; }
        | { $$ = pilha_cria(); }
        ;
l:      n PONTO_E_VIRGULA l
        |
        ;
c:      IDENTIFICADOR ATRIBUICAO a {
            variavel_verifica_tipo($1, $3.ehInteiro);
        }
        | LER r
        | ESCREVER w
        | m
        | ENQUANTO ABRE_PARENTESES b FECHA_PARENTESES FACA n
        ;
a:      e { $$ = $1; }
        | VERDADEIRO { $$ = $1; }
        | FALSO { $$ = $1; }
        ;
r:      ABRE_PARENTESES i FECHA_PARENTESES {
            while(!pilha_vazia($2)) {
                variavel_acessa(pilha_remove($2));
            }
            pilha_destroi($2);
        }
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
m:      INICIO l FIM
        ;
n:      SE b ENTAO n1
        | c
        ;
n1:     n 
        | SENAO n
        ;
e:      x e1 { $$.ehInteiro = true; }
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
y:      SUBTRACAO k { $$ = $2; }
        | k { $$ = $1; }
        ;
k:      ABRE_PARENTESES e FECHA_PARENTESES {
            $$ = $2;
        }
        | IDENTIFICADOR {
            $$.ehInteiro = variavel_acessa($1);
        }
        | NUMERO {
            $$.ehInteiro = true;
        }
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
    fprintf(stderr, "[%s]: Token [%s] Linha [%d] Coluna [%d]\n", s, yytext, yylineno, yycolno);
}

void variavel_declara(char* identificador, bool ehInteiro) {
    valor_t valor;

    bool existe = edb_busca(tabela_variaveis, identificador, &valor);
    if(existe) {
        fprintf(stderr, "Variável [%s] já declarada ", identificador);
        yyerror("semantical error");
    }

    valor.ehInteiro = ehInteiro;
    valor.chave = identificador;
    edb_insere(tabela_variaveis, identificador, valor);

    /* printf("Declarei a variável %s como %d\n", identificador, ehInteiro); */
}

bool variavel_acessa(char* identificador) {
    valor_t valor;

    bool existe = edb_busca(tabela_variaveis, identificador, &valor);
    if(!existe) {
        yyerror("semantical error");
        fprintf(stderr, "\t\tVariável [%s] não declarada\n", identificador);
    } else {
        /* printf("Acessei a variável [%s]\n", identificador); */
    }

    return valor.ehInteiro;
}

void variavel_verifica_tipo(char* identificador, bool ehInteiro) {
    if(variavel_acessa(identificador) == ehInteiro) return;

    yyerror("semantical error");
    if(ehInteiro) {
        fprintf(stderr, "\t\tVariável [%s] do tipo [LÓGICO] não pode receber expressão do tipo [INTEIRO]\n", identificador);
    }else {
        fprintf(stderr, "\t\tVariável [%s] do tipo [INTEIRO] não pode receber expressão do tipo [LÓGICO]\n", identificador);
    }
}

int main() {
    tabela_variaveis = edb_cria();
    yyparse();
    edb_destroi(tabela_variaveis);

    return EXIT_SUCCESS;
}