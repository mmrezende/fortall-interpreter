#include "token.h"

token_t* token_cria() {
    return calloc(1, sizeof(token_t));
}

void token_destroi(token_t* self) {
    free(self);
}