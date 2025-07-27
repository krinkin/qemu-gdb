AS = riscv64-linux-gnu-as
LD = riscv64-linux-gnu-ld

hello: hello.s
	$(AS) -o hello.o hello.s
	$(LD) -Ttext=0x80000000 -o hello hello.o

clean:
	rm -f hello hello.o

.PHONY: clean