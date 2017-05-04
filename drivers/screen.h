#ifndef SCREEN_H
#define SCREEN_H

#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80

//Attribute byte for default color schema
#define WHITE_ON_BLACK 0x0f

// Screen device I/O ports
#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5

void print_char(char, int, int, char);
int get_screen_offset(int, int);
int get_cursor();
void set_cursor(int);
void print_at(char*, int, int);
void print(char* message);
void clear_screen();
void mem_copy(char*, char*, int);
int handle_scrolling(int);
void fprint(char*,int);
char* int_to_string(int);
char to_char(int);

#endif
