CC := gcc
LEX := lex
CFLAGS := -Wall -Wextra -Ishared
LDFLAGS := -ll

SRC_DIR := src
TARGET_DIR := targets

# Get all .c files in the src directory
C_FILES := $(wildcard $(SRC_DIR)/*.c)

# Generate corresponding .o file names
O_FILES := $(patsubst $(SRC_DIR)/%.c,$(TARGET_DIR)/%.o,$(C_FILES))

.PHONY: all clean

all: $(TARGET_DIR)/sintatico

# Compile .c files to .o files
$(TARGET_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# Run lex on sintatico.l and output to .c file
$(TARGET_DIR)/lex.yy.c: $(SRC_DIR)/sintatico.l
	$(LEX) -o $@ $<

# Compile lex output and link with .o files
$(TARGET_DIR)/sintatico: $(TARGET_DIR)/lex.yy.c $(O_FILES)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

clean:
	rm -f $(TARGET_DIR)/*.o $(TARGET_DIR)/lex.yy.c $(TARGET_DIR)/sintatico
