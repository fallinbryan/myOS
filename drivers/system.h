#ifndef SYSTEM_H
#define SYSTEM_H

unsigned char* memset(unsigned char* dest, unsigned char val, int cout);
unsigned short* memsetw(unsigned short* dest, unsigned short val, int cout);
int strlen(const char* str);

void idt_set_gate(unsigned char num, unsigned long base, unsigned short sel, unsigned char flags);
void idt_install();
//extern void _idt_load();



/* This defines what the stack looks like after an ISR was running */
struct regs
{
    unsigned int gs, fs, es, ds;      /* pushed the segs last */
    unsigned int edi, esi, ebp, esp, ebx, edx, ecx, eax;  /* pushed by 'pusha' */
    unsigned int int_no, err_code;    /* our 'push byte #' and ecodes do this */
    unsigned int eip, cs, eflags, useresp, ss;   /* pushed by the processor automatically */ 
};

void fault_handler(struct regs* r);
void isrs_install();
#endif
