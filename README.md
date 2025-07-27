# RISC-V Hello World with QEMU Monitor

Simple RISC-V assembly program that prints "hello" with step-by-step execution monitoring.

## Requirements

- `riscv64-linux-gnu-gcc` toolchain
- `qemu-system-riscv64` 
- `gdb-multiarch`

## Usage

```bash
# Build
make

# Monitor execution (3 steps by default)
./monitor.sh hello

# Monitor with custom step count
./monitor.sh hello 5