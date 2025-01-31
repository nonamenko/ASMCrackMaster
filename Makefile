# Makefile for ASMCrackMaster

all: ASMCrackMaster

ASMCrackMaster: ASMCrackMaster.o
	gcc ASMCrackMaster.o -o ASMCrackMaster

ASMCrackMaster.o: ASMCrackMaster.asm
	nasm -f elf64 ASMCrackMaster.asm -o ASMCrackMaster.o

clean:
	rm -f ASMCrackMaster ASMCrackMaster.o
