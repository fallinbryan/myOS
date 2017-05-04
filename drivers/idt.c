#include "system.h"

//Defines an IDT entry ~ Interrupt Descriptor Table

struct idt_entry {
	unsigned short base_lo;
	unsigned short sel;			//kernel code segment goes here
	unsigned char always0;		// This will always be set to 0
	unsigned char flags;		// Set using the above table
	unsigned short base_hi;
} __attribute__((packed));

struct idt_ptr {
	unsigned short limit;
	unsigned int base;
} __attribute__((packed));

/*
* Declare an IDT of 256 entries
* If any undefined IDT entry is hit
* it normally will cause an "Unhandled
* Interrupt" exception
*/

struct idt_entry idt[256];
struct idt_ptr   idtp;

extern void _idt_load();

void idt_set_gate(unsigned char num, unsigned long base, unsigned short sel, unsigned char flags) {
	idt[num].base_lo = (base & 0xfff);
	idt[num].base_hi = (base >> 16) & 0xffff;
	idt[num].sel = sel;
	idt[num].always0 = 0;
	idt[num].flags = flags;
	print("idt_set_gate");

}


void idt_install() {
	
	// Sets the IDT pointer up
	print("idt_install");
	idtp.limit = (sizeof (struct idt_entry) * 256) -1;
	idtp.base  = &idt;

	// Clear the entire IDT, init to all zeros
	memset(&idt, 0, sizeof(struct idt_entry) * 256);


	// Add new ISRs to the IDT here with idt_set_gate

	// Points the processors internal register to the new IDT
	_idt_load();
}
