# Interpretador da Pseudolinguagem Fortall

## Este projeto consiste de um parser completo, envolvendo a análise léxica, sintática e semântica da pseudolinguagem Fortall, definida em: [fortall.pdf](fortall.pdf)
---
### Além disso, parte da interpretação em tempo real dos comandos da linguagem também é realizada.
---
### Para compilar o executável, basta:
#### `$ make`
#### `$ ./targets/analisador < programas/<nome_do_programa>`
#### Onde **<nome_do_programa>** corresponde ao nome do arquivo *.fall* na pasta **programas**
#### A entrada e saída do programa deve ser passada/obtida nos arquivos *input.txt* e *output.txt*, respectivamente.
---
### Observações:
 - Todos os arquivos fonte se encontram na pasta **src**
 - Todas as interfaces se encontram na pasta **shared**
 - Todos os arquivos compilados (incluindo lex e yacc) se encontram na pasta **targets**
 - As expressões regulares para os *tokens* se encontram em **src/lexico.l**
 - Todas as derivações da Gramática Livre de Contextos (**GLC**), incluindo suas respectivas ações semânticas e as instruções do interpretador se encontram em **src/sintatico.y**
---
### Sobre o projeto:
#### A implementação do parser foi feita utilizando **LEX** (para a análise léxica) e **YACC** (responsável pela análise sintática e semântica). Além disso, algumas derivações correspondem a ações semânticas que são executadas pelo interpretador, que também se encontra em **src/sintatico.y**.
#### Foram realizadas algumas fatorações na gramática original, incluindo:
- Remoção da ambiguidade na estrutura **SE/SENAO**
- Simplificação de alguns não-terminais desnecessários
- Produção adicional para permitir **INICIO** {vazio} **FIM**, isto é, um programa vazio.
- Refatoração das expressões aritméticas, permitindo ambiguidades, que são removidas explicitamente ao definir a precedência dos operadores.

#### O interpretador funciona parcialmente. A princípio, as atribuições de variáveis, os comandos **LER** e **ESCREVER** e as expressões aritméticas se comportam como esperado.

#### No entanto, estruturas mais complexas como **SE/SENAO** e **ENQUANTO** estão incompletas.