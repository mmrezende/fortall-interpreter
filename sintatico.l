/* letra = a */

%%
\{.*\} ;
. printf("%s", yytext);
%%
#include "token.h"