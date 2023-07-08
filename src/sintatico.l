letra [A-Za-z]
digito [0-9]
digito_nao_nulo [1-9]

inteiro (I|i)(N|n)(T|t)(E|e)(I|i)(R|r)(O|o)
logico (L|l)(O|o|Ó|ó)(G|g)(I|i)(C|c)(O|o)
ler (L|l)(E|e)(R|r)
escrever (E|e)(S|s)(C|c)(R|r)(E|e)(V|v)(E|e)(R|r)
enquanto (E|e)(N|n)(Q|q)(U|u)(A|a)(N|n)(T|t)(O|o)
faca (F|f)(A|a)(C|c|Ç|ç)(A|a)
se (S|s)(E|e)
entao (E|e)(N|n)(T|t)(A|a|Ã|ã)(O|o)
senao (S|s)(E|e)(N|n)(A|a|Ã|ã)(O|o)
soma \+
subtracao -
multiplicacao \*
divisao \/
igual =
diferente <>
menor <
menor_ou_igual <=
maior >
maior_ou_igual >=
comentario \{.*\}
atribuicao :=
declaracao (V|v)(A|a)(R|r)
programa (P|p)(R|r)(O|o)(G|g)(R|r)(A|a)(M|m)(A|a)
inicio (I|i)(N|n)(I|i|Í|í)(C|c)(I|i)(O|o)
fim (F|f)(I|i)(M|m)
ponto_e_virgula ;
dois_pontos :
abre_parenteses \(
fecha_parenteses \)
identificador ({letra}|_)({letra}|{digito}|_)*
string '.*'
numero {digito_nao_nulo}+{digito}*

%%
{inteiro} printf("Encontrei um token do tipo [inteiro]\n") ;
{logico} printf("Encontrei um token do tipo [logico]\n") ;
{ler} printf("Encontrei um token do tipo [ler]\n") ;
{escrever} printf("Encontrei um token do tipo [escrever]\n") ;
{enquanto} printf("Encontrei um token do tipo [enquanto]\n") ;
{faca} printf("Encontrei um token do tipo [faca]\n") ;
{se} printf("Encontrei um token do tipo [se]\n") ;
{entao} printf("Encontrei um token do tipo [entao]\n") ;
{senao} printf("Encontrei um token do tipo [senao]\n") ;
{soma} printf("Encontrei um token do tipo [soma]\n") ;
{subtracao} printf("Encontrei um token do tipo [subtracao]\n") ;
{multiplicacao} printf("Encontrei um token do tipo [multiplicacao]\n") ;
{divisao} printf("Encontrei um token do tipo [divisao]\n") ;
{igual} printf("Encontrei um token do tipo [igual]\n") ;
{diferente} printf("Encontrei um token do tipo [diferente]\n") ;
{menor} printf("Encontrei um token do tipo [menor]\n") ;
{menor_ou_igual} printf("Encontrei um token do tipo [menor_ou_igual]\n") ;
{maior} printf("Encontrei um token do tipo [maior]\n") ;
{maior_ou_igual} printf("Encontrei um token do tipo [maior_ou_igual]\n") ;
{comentario} printf("Encontrei um token do tipo [comentario]\n") ;
{atribuicao} printf("Encontrei um token do tipo [atribuicao]\n") ;
{declaracao} printf("Encontrei um token do tipo [declaracao]\n") ;
{programa} printf("Encontrei um token do tipo [programa]\n") ;
{inicio} printf("Encontrei um token do tipo [inicio]\n") ;
{fim} printf("Encontrei um token do tipo [fim]\n") ;
{ponto_e_virgula} printf("Encontrei um token do tipo [ponto_e_virgula]\n") ;
{dois_pontos} printf("Encontrei um token do tipo [dois_pontos]\n") ;
{abre_parenteses} printf("Encontrei um token do tipo [abre_parenteses]\n") ;
{fecha_parenteses} printf("Encontrei um token do tipo [fecha_parenteses]\n") ;
{identificador} printf("Encontrei um token do tipo [identificador]\n") ;
{string} printf("Encontrei um token do tipo [string]\n") ;
{numero} printf("Encontrei um token do tipo [numero]\n") ;
[ \t\n] ;
. printf("Token inesperado: [%s]\n", yytext);
%%
#include "token.h"