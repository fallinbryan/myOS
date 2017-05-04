#include "../drivers/screen.h"

void main() {
	clear_screen();
	print("Bryan OS booting, Kernel is bootstrapped and loaded\n");
	print("Loading IDT\n");
	idt_install();
	isrs_install();
	
	
	int i = 32;
	print("\ntesting fprint(\"%d is a number,i)\n");
	fprint("%d is a number",i);
	//todo make print_int() work
	//print_int(123);
	
	
	
	
	
}
