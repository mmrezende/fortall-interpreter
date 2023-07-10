CC := gcc
LEX := lex
YACC := yacc
CFLAGS := -Wall -Wextra -Ishared
LDFLAGS := -ll

SRC_DIR := src
TARGET_DIR := targets

all: $(TARGET_DIR)/analisador

# Get all .c files in the src directory
C_FILES := $(wildcard $(SRC_DIR)/*.c)

# Generate corresponding .o file names
O_FILES := $(patsubst $(SRC_DIR)/%.c,$(TARGET_DIR)/%.o,$(C_FILES))

# Compile .c files to .o files
$(TARGET_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# Run yacc on sintatico.y and output to .c file
$(TARGET_DIR)/y.tab.c $(TARGET_DIR)/y.tab.h: $(SRC_DIR)/sintatico.y
	$(YACC) -d -o $@ $< -Wcounterexamples

# Run lex on lexico.l and output to .c file
$(TARGET_DIR)/lex.yy.c: $(SRC_DIR)/lexico.l
	$(LEX) -o $@ $<

# Link everything
$(TARGET_DIR)/analisador: $(TARGET_DIR)/y.tab.c $(TARGET_DIR)/lex.yy.c $(O_FILES)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS) && touch input.txt && touch output.txt


clean:
	rm -f $(TARGET_DIR)/*.o $(TARGET_DIR)/y.tab.c $(TARGET_DIR)/y.tab.h $(TARGET_DIR)/lex.yy.c $(TARGET_DIR)/analisador $(O_FILES)
