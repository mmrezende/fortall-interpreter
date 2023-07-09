%{
    #include "y.tab.h"
    #include <stdlib.h>
    void yyerror(char*);
    int yycolno = 1;
%}

letra [A-Za-z]
digito [0-9]
digito_nao_nulo [1-9]

%%
(I|i)(N|n)(T|t)(E|e)(I|i)(R|r)(O|o) {
    yycolno += yyleng;
    return INTEIRO;
}
(L|l)(O|o|Ó|ó)(G|g)(I|i)(C|c)(O|o) {
    yycolno += yyleng;
    return LOGICO;
}
(V|v)(E|e)(R|r)(D|d)(A|a)(D|d)(E|e)(I|i)(R|r)(O|o) {
    yycolno += yyleng;
    return VERDADEIRO;
}
(F|f)(A|a)(L|l)(S|s)(O|o) {
    yycolno += yyleng;
    return FALSO;
}
(L|l)(E|e)(R|r) {
    yycolno += yyleng;
    return LER;
}
(E|e)(S|s)(C|c)(R|r)(E|e)(V|v)(E|e)(R|r) {
    yycolno += yyleng;
    return ESCREVER;
}
(E|e)(N|n)(Q|q)(U|u)(A|a)(N|n)(T|t)(O|o) {
    yycolno += yyleng;
    return ENQUANTO;
}
(F|f)(A|a)(C|c|Ç|ç)(A|a) {
    yycolno += yyleng;
    return FACA;
}
(S|s)(E|e) {
    yycolno += yyleng;
    return SE;
}
(E|e)(N|n)(T|t)(A|a|Ã|ã)(O|o) {
    yycolno += yyleng;
    return ENTAO;
}
(S|s)(E|e)(N|n)(A|a|Ã|ã)(O|o) {
    yycolno += yyleng;
    return SENAO;
}
\+ {
    yycolno += yyleng;
    return SOMA;
}
- {
    yycolno += yyleng;
    return SUBTRACAO;
}
\* {
    yycolno += yyleng;
    return MULTIPLICACAO;
}
\/ {
    yycolno += yyleng;
    return DIVISAO;
}
= {
    yycolno += yyleng;
    return IGUAL;
}
\<\> {
    yycolno += yyleng;
    return DIFERENTE;
}
\< {
    yycolno += yyleng;
    return MENOR;
}
\<= {
    yycolno += yyleng;
    return MENOR_OU_IGUAL;
}
\> {
    yycolno += yyleng;
    return MAIOR;
}
\>= {
    yycolno += yyleng;
    return MAIOR_OU_IGUAL;
}
:= {
    yycolno += yyleng;
    return ATRIBUICAO;
}
(V|v)(A|a)(R|r) {
    yycolno += yyleng;
    return DECLARACAO;
}
(P|p)(R|r)(O|o)(G|g)(R|r)(A|a)(M|m)(A|a) {
    yycolno += yyleng;
    return PROGRAMA;
}
(I|i)(N|n)(I|i|Í|í)(C|c)(I|i)(O|o) {
    yycolno += yyleng;
    return INICIO;
}
(F|f)(I|i)(M|m) {
    yycolno += yyleng;
    return FIM;
}
\; {
    yycolno += yyleng;
    return PONTO_E_VIRGULA;
}
, {
    yycolno += yyleng;
    return VIRGULA;
}
: {
    yycolno += yyleng;
    return DOIS_PONTOS;
}
\( {
    yycolno += yyleng;
    return ABRE_PARENTESES;
}
\) {
    yycolno += yyleng;
    return FECHA_PARENTESES;
}
({letra}|_)({letra}|{digito}|_)* {
    yycolno += yyleng;
    return IDENTIFICADOR;
}
'[^']*' {
    yycolno += yyleng;
    return STRING;
}
({digito_nao_nulo}+{digito}*|{digito}) {
    yycolno += yyleng;
    return NUMERO;
}
\{.*\} ; /* comentário */
[ \t] ;
\n {
    yylineno++;
    yycolno = 1;
};
. yyerror("Caractere desconhecido");
%%
int yywrap(void) {
    return 1;
}