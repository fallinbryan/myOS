#include "../drivers/screen.h"

void main() {
	clear_screen();
	print("Bryan OS booting, Kernel is bootstrapped and loaded\n");
	print("Loading IDT\n");
	idt_install();
	isrs_install();
	
	print("About to divide by zero");
	for(int i = 0; i < 0xffffff; i++){
		for(int j = 0; j < 0xa; j++){
		
		}
	}
	
	for(int i = 0; i < 0xffffff; i++){
	}
	for(int i = 0; i < 0xffffff; i++){
	}
	int i = 32/0;
	print("\ntesting fprint(\"%d is a number,i)\n");
	fprint("%d is a number\n",i);
	//todo make print_int() work
	//print_int(123);
	
	
	
	
	
}
