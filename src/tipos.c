#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "tipos.h"

// Imprime o conteúdo de um valor_t
void imprime_valor(valor_t valor) {
    if(valor.ehInteiro) {
        printf("[%s, Inteiro, %d]\n", valor.chave, valor.intVal);
    } else {
        printf("[%s, Lógico, %d]\n", valor.chave, valor.boolVal);
    }
    
}

void imprime_dado(dado_t dado) {
    printf("%s", dado);
}

// Desaloca o conteúdo armazenado num valor_t (caso necessário)
void libera_valor(valor_t valor) {
    free(valor.chave);
}

/**
 * Função para comparar dois valores, que retorna:
 * =0 - se são iguais
 * <0 - se chave corresponde a valor que deve estar antes do valor
 * >0 - se chave corresponde a valor que deve estar depois do valor
 */
int compara_chave_valor(chave_t c, valor_t v)
{
    return strcmp(c, v.chave);
}