%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdbool.h>
    #include "edb.h"
    #include "tipos.h"
    #include "pilha.h"

    int yylex(void);
    void yyerror(char *);
    void variavel_declara(char*, bool); // declara a variável e a coloca na tabela de variáveis
    void variavel_acessa(char*, valor_t*); // acessa a variável e coloca o valor em pvalor
    void variavel_le(char*); // le o conteúdo para uma variavel do arquivo_de_entrada
    void variavel_atualiza(char*, valor_t);  // atualiza o conteúdo de uma variável
    extern int yylineno, yycolno;
    extern char* yytext;

    edb_t* tabela_variaveis;
    pilha_t* pilha_variaveis;
    FILE *arquivo_de_entrada, *arquivo_de_saida;
%}

%union
{
    char* stringVal;
    void* ptrVal;
    int intVal;
    struct {
        int intVal;
        bool boolVal;
        bool ehInteiro;
        char operacao;
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
*/
%left SOMA SUBTRACAO
%left MULTIPLICACAO DIVISAO

%start s

%type <ptrVal> i i1
%type <boolVal> t b
%type <intVal> e y
%type <expressao> k a

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
a:      e { $$.ehInteiro = true; }
        | VERDADEIRO { $$ = $1; }
        | FALSO { $$ = $1; }
        ;
r:      ABRE_PARENTESES i FECHA_PARENTESES {
            while(!pilha_vazia($2)) {
                variavel_le(pilha_remove($2));
            }
            pilha_destroi($2);
        }
        |
        ;
w:      ABRE_PARENTESES f FECHA_PARENTESES
        |
        ;
f:      g VIRGULA f
        | g
        ;
g:      STRING { fprintf(arquivo_de_saida, "%s", $1); }
        | e { fprintf(arquivo_de_saida, "%d", $1); }
        ;
m:      INICIO l FIM
        ;
n:      SE b ENTAO n1
        | c
        ;
n1:     n 
        | SENAO n
        ;
e:      e SOMA e { $$ = $1 + $3; }
        | e SUBTRACAO e { $$ = $1 - $3; }
        | e MULTIPLICACAO e { $$ = $1 * $3; }
        | e DIVISAO e { $$ = $1 / $3; }
        | y { $$ = $1; }
        ;
y:      SUBTRACAO k { 
            if(!$2.ehInteiro) {
                yyerror("semantical error");
                fprintf(stderr, "\t\tEsperado uma expressão do tipo [INTEIRO]\n");
            }
            $$ = -$2.intVal;
        }
        | k {
            if(!$1.ehInteiro) {
                yyerror("semantical error");
                fprintf(stderr, "\t\tEsperado uma expressão do tipo [INTEIRO]\n");
            }
            $$ = $1.intVal;
        }
        ;
k:      ABRE_PARENTESES e FECHA_PARENTESES {
            $$.ehInteiro = true;
        }
        | IDENTIFICADOR {
            valor_t valor;
            variavel_acessa($1, &valor);
            $$.ehInteiro = valor.ehInteiro;
            $$.intVal = valor.intVal;
        }
        | NUMERO {
            $$.intVal = $1.intVal;
            $$.ehInteiro = true;
        }
        ;
b:      e IGUAL e { $$ = $1 == $3; }
        | e MENOR e { $$ = $1 < $3; }
        | e DIFERENTE e { $$ = $1 != $3; }
        | e MENOR_OU_IGUAL e { $$ = $1 <= $3; }
        | e MAIOR e { $$ = $1 > $3; }
        | e MAIOR_OU_IGUAL e { $$ = $1 >= $3; }
        ;
c:      IDENTIFICADOR ATRIBUICAO a {
            valor_t conteudo;
            conteudo.ehInteiro = $3.ehInteiro;
            conteudo.intVal = $3.intVal;
            conteudo.boolVal = $3.boolVal;
            variavel_atualiza($1, conteudo);
        }
        | LER r
        | ESCREVER w { fprintf(arquivo_de_saida, "\n"); }
        | m
        | ENQUANTO ABRE_PARENTESES b FECHA_PARENTESES FACA n
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

void variavel_acessa(char* identificador, valor_t* pvalor) {
    bool existe = edb_busca(tabela_variaveis, identificador, pvalor);
    if(!existe) {
        yyerror("semantical error");
        fprintf(stderr, "\t\tVariável [%s] não declarada\n", identificador);
    } else {
        /* printf("Acessei a variável [%s]. Ela tem o valor [%d]\n", identificador, pvalor->intVal); */
    }
}

void variavel_atualiza(char* identificador, valor_t conteudo) {
    valor_t valor;
    variavel_acessa(identificador, &valor);

    if(!valor.ehInteiro == conteudo.ehInteiro) {
        if(valor.ehInteiro) {
            fprintf(stderr, "\t\tVariável [%s] do tipo [LÓGICO] não pode receber expressão do tipo [INTEIRO]\n", identificador);
        }else {
            fprintf(stderr, "\t\tVariável [%s] do tipo [INTEIRO] não pode receber expressão do tipo [LÓGICO]\n", identificador);
        }
        yyerror("semantical error");
        return;
    }

    if(valor.ehInteiro) {
        valor.intVal = conteudo.intVal;
    } else {
        valor.boolVal = conteudo.boolVal;
    }
    edb_insere(tabela_variaveis, identificador, valor);
}

void variavel_le(char* identificador) {
    valor_t valor;
    variavel_acessa(identificador, &valor);
    if(valor.ehInteiro) {
        fscanf(arquivo_de_entrada, "%d", &valor.intVal);
    } else {
        int aux;
        fscanf(arquivo_de_entrada, "%d", &aux);
        valor.boolVal = aux != 0;
    }
    edb_insere(tabela_variaveis, identificador, valor);
}

int main() {
    arquivo_de_entrada = fopen("input.txt", "r");
    arquivo_de_saida = fopen("output.txt", "w");
    if(arquivo_de_entrada == NULL || arquivo_de_saida == NULL) {
        yyerror("fatal error: failed to open i/o files");
        return EXIT_FAILURE;
    }
    tabela_variaveis = edb_cria();
    yyparse();
    edb_destroi(tabela_variaveis);

    return EXIT_SUCCESS;
}