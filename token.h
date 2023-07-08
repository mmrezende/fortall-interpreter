#if !defined(TOKEN_H)
#define TOKEN_H
/**
 * Interface que define a estrutura dos tokens
 * e funções auxiliares para manipulá-los
*/

typedef enum {
    // tipos primitivos
    INTEIRO,
    LOGICO,
    // entrada e saída
    LER,
    ESCREVER,
    // estruturas de repetição
    ENQUANTO,
    FACA,
    // estruturas condicionais
    SE,
    ENTAO,
    SENAO,
    // operadores aritméticos
    SOMA,
    SUBTRACAO,
    MULTIPLICACAO,
    DIVISAO,
    // operadores relacionais
    IGUAL,
    DIFERENTE,
    MENOR,
    MENOR_OU_IGUAL,
    MAIOR,
    MAIOR_OU_IGUAL,
    // comentários
    COMENTARIO,
    // atribuições
    ATRIBUICAO,
    // declaração de variáveis
    DECLARACAO,
    // delimitadores
    PROGRAMA,
    INICIO,
    FIM,
    PONTO_E_VIRGULA,
    DOIS_PONTOS,
    ABRE_PARENTESES,
    FECHA_PARENTESES,

    // tokens variáveis (que precisam de uma tabela auxiliar)
    IDENTIFICADOR,
    STRING,
    NUMERO
} classe_t;

typedef struct {
    // linha e coluna que foi encontrado pelo analisador léxico
    size_t linha;
    size_t coluna;
    // classe do token (identificador, palavra reservada, delimitador etc)
    classe_t classe;
    /**
     * atributo auxiliar para encontrar o valor do token na tabela de símbolos
     * respectiva (caso o mesmo seja um token variável)
    */
    size_t indice;
} token_t;

// aloca e retorna uma estrutura token_t
token_t* token_cria();
// desaloca uma estrutura token_t
void token_destroi(token_t* self);

#endif // TOKEN_H
