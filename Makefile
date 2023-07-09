CC := gcc
LEX := lex
YACC := yacc
CFLAGS := -Wall -Wextra -Ishared
LDFLAGS := -ll

SRC_DIR := src
TARGET_DIR := targets

all: $(TARGET_DIR)/analisador

# Run yacc on sintatico.y and output to .c file
$(TARGET_DIR)/y.tab.c $(TARGET_DIR)/y.tab.h: $(SRC_DIR)/sintatico.y
	$(YACC) -d -o $@ $<

# Run lex on lexico.l and output to .c file
$(TARGET_DIR)/lex.yy.c: $(SRC_DIR)/lexico.l
	$(LEX) -o $@ $<

# Link everything
$(TARGET_DIR)/analisador: $(TARGET_DIR)/y.tab.c $(TARGET_DIR)/lex.yy.c
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)


clean:
	rm -f $(TARGET_DIR)/*.o $(TARGET_DIR)/y.tab.c $(TARGET_DIR)/y.tab.h $(TARGET_DIR)/lex.yy.c $(TARGET_DIR)/analisador
