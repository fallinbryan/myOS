#include "screen.h"


/*
   Print a char on the screen at col, row, or at cursor pos
   Create a byte (char) pointer to the start of the video memory
   If attribute bute is zero, assume the default style
*/
void print_char(char character, int row, int col, char attr) {
	int offset = 0;
	char* video_addr = (char*)VIDEO_ADDRESS;
	if(!attr) { attr = WHITE_ON_BLACK; }
	if( col < 0 && row < 0 ) {
		offset = get_cursor();
	} else {
		offset = get_screen_offset(row, col);
	}
	if (character == '\n') {
		int current_col = 0;
		int current_row = offset / (2*MAX_COLS);
		current_row += 1;
		offset = get_screen_offset(current_row,current_col);
		
	} else {
		video_addr[offset] = character;
		video_addr[offset+1] = attr;
	}
	
	offset+=2;
	offset = handle_scrolling(offset);
	set_cursor(offset);
}

int get_screen_offset(int row, int col) {
	
	return 2*((row*MAX_COLS)+col);
	
}



int get_cursor() {
	// The device uses its control register as an index to 
	// select ins internal registers, of which we are insterested in
	// reg 14: high byte of the cursor's offset
	// reg 15: low  byte of the cursor's offset
	// Once the interneal register has been selected, we may read or write
	// a byte on the data register
	int rv;
	port_byte_out(REG_SCREEN_CTRL, 0x0E);
	unsigned char offset = port_byte_in(REG_SCREEN_DATA);
	rv = (int)(offset) << 8;
	port_byte_out(REG_SCREEN_CTRL, 0x0F);
	offset = port_byte_in(REG_SCREEN_DATA);
	rv += (int)(offset);
	// Since the cursor offset reported by the VGA hardware is the 
	// number of characters, we multiply by two to convert it to
	// a char cell offset.
	return rv*2;
}

void set_cursor(int offset) {
	offset /= 2;
	//cursor LOW port to vga INDEX register
	port_byte_out(REG_SCREEN_CTRL, 0x0F);
	port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset & 0xFF));

	//cursor HIGH port to vga INDEX register
	port_byte_out(REG_SCREEN_CTRL, 0x0E);
	port_byte_out(REG_SCREEN_DATA, (unsigned char)((offset>>8)&0xFF));
}

void print_at(char* message, int row, int col) {
	// Update the cursor if col and row are non-negative
	if(col >=0 && row >= 0 ) {
		set_cursor(get_screen_offset(row,col));
	}
	
	int i = 0;
	while(message[i] != 0) {
		print_char(message[i++], row, col, WHITE_ON_BLACK);
	}
}

void print(char* message) {
	print_at(message, -1, -1);
}

void clear_screen() {
	for(int row = 0; row < MAX_ROWS; row++) {
		for (int col = 0; col < MAX_COLS; col++) {
		
			
			print_char(' ', row, col, WHITE_ON_BLACK);
		}
	}
	set_cursor(get_screen_offset(0,0));
}

// Copy bytes from one place to another
void memory_copy(char* source, char* dest, int no_bytes) {
	for(int i = 0; i < no_bytes; i++) {
		*(dest+i) = *(source + i);
	}
}

// Advance the text cursor, scrolling the video buffer if necessary
int handle_scrolling(int cursor_offset) {
	if (cursor_offset < MAX_ROWS * MAX_COLS * 2 ) {
		return cursor_offset;
	}
	
	//Shuffle the rows back one
	for(int i = 0; i < MAX_ROWS; i++) {
		memory_copy((char*)(get_screen_offset(i,0) + VIDEO_ADDRESS),
			        (char*)(get_screen_offset(i-1,0) + VIDEO_ADDRESS),
			         MAX_COLS*2 );
	}

	// Blank the last line by setting all bytes to 0
	char* last_line = (char*)(get_screen_offset(MAX_ROWS-1, 0) + VIDEO_ADDRESS);
	for(int i = 0; i < MAX_COLS*2; i++) {
		last_line[i] = 0;
	}

	// Move the offset back one row so that it now on the last row
	cursor_offset -= 2*MAX_COLS;

	return cursor_offset;
}

void fprint(char* str,int num) {
	char* partial_front = str;
	char* partial_back = 0;
	char* number = int_to_string(num);
	int i = 0;
	while(str[i++] != 0 ) {
		if(str[i] == '%d') {
			partial_front[i] = 0;
			partial_back = str[i+2];
			i += 2;
		}
	}
	print(partial_front);
	print(number);
	print(partial_back);
	
	
}

char* int_to_string(int val) {
	int size = 0;
	int tmp = val;
	char* rv;
	while(tmp > 0) {
		size += 1;
		tmp /= 10;
	}
	
	
	for(int i = size-1; i >= 0; i-- ) {
		rv[i] = to_char(val % 10);
		val /= 10;
	}
	rv[size] = 0;
	return rv;
}


/*
48	30	00110000	0	zero
49	31	00110001	1	one
50	32	00110010	2	two
51	33	00110011	3	three
52	34	00110100	4	four
53	35	00110101	5	five
54	36	00110110	6	six
55	37	00110111	7	seven
56	38	00111000	8	eight
57	39	00111001	9	nine
*/
char to_char(int val) {
	return (char)(val + 48);
}