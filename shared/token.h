#if !defined(TOKEN_H)
#define TOKEN_H
/**
 * Interface que define a estrutura dos tokens
 * e funções auxiliares para manipulá-los
*/

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

#endif // TOKEN_H
