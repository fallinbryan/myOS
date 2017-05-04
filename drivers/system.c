#include "system.h"

unsigned char* memset(unsigned char* dest, unsigned char val, int count) {
	for(int i = 0; i < count; i++) {
		dest[i] = val;
	}
	//todo if fail return null
	return dest;
}

unsigned short* memsetw(unsigned short* dest, unsigned short val, int count) {
	for(int i=0; i < count; i++) {
		dest[i] = val;
	}
	//todo if fail return null
	return dest;
}

int strlen(const char* str) {
	short i = 0;
	while(str[i++] != 0) {}
	return (int)i;
}

