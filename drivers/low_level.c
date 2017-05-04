//A handy C wrapper func that reads a byte from the spec port
// 	"=a"(result) : put AL reg in var result when finished
//	"d"(port)    : load EDX with port

unsigned char port_byte_in(unsigned short port) {
	unsigned char result;
	__asm__("in %%dx, %%al" : "=a"(result) : "d"(port));
	return result;
}

// "a"(data) : load EAX with data
// "d"(port) : load EDX with port
void port_byte_out(unsigned short port, unsigned char data) {
	__asm__("out %%al, %%dx" : : "a" (data), "d"(port));
}

unsigned short port_word_in( unsigned short port ) {
	unsigned short result;
	__asm__("in %%dx, %%ax" : "=a"(result) : "d"(port));
	return result;
}

void port_word_out(unsigned short port, unsigned short data) {
	__asm__("out %%ax, %%dx" : : "a"(data), "d"(port));
}


/*
 IN reads a byte, word or doubleword from the specified I/O port,
 and stores it in the given destination register. The port number
 may be specified as an immediate value if it is between 0 and 255,
 and otherwise must be stored in DX. See also OUT
 
 OUT writes the contents of the given source register to the specified
 I/O port. The port number may be specified as an immediate value if 
 it is between 0 and 255, and otherwise must be stored in DX.
 
*/