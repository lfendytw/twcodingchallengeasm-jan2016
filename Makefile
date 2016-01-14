build:
	/usr/bin/nasm -f macho main.asm
	ld -macosx_version_min 10.7.0 -o go main.o
