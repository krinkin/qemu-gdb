#!/bin/bash

BINARY=${1:-hello}
STEPS=${2:-3}

echo "Monitoring $BINARY for $STEPS steps..."

ENTRY=$(riscv64-linux-gnu-objdump -t "$BINARY" | grep " _start$" | awk '{print $1}')
echo "Our code starts at: 0x$ENTRY"

qemu-system-riscv64 -machine virt -bios none -kernel "$BINARY" -s -S -nographic &
QEMU_PID=$!
sleep 1

# Генерируем GDB команды динамически
GDB_COMMANDS="-ex \"file $BINARY\" -ex \"target remote localhost:1234\" -ex \"set architecture riscv:rv64\" -ex \"set pagination off\" -ex \"b *0x$ENTRY\" -ex \"continue\""

# Добавляем начальное состояние
GDB_COMMANDS="$GDB_COMMANDS -ex \"printf \\\"\\\\n=== STEP 0 ===\\\\n\\\"\" -ex \"x/1i \\\$pc\" -ex \"info registers t0 t1 t2\""

# Генерируем команды для каждого шага
for ((i=1; i<=STEPS; i++)); do
    GDB_COMMANDS="$GDB_COMMANDS -ex \"stepi\" -ex \"printf \\\"\\\\n=== STEP $i ===\\\\n\\\"\" -ex \"x/1i \\\$pc-4\" -ex \"info registers t0 t1 t2\""
done

GDB_COMMANDS="$GDB_COMMANDS -ex \"quit\""

# Выполняем GDB
eval "gdb-multiarch -batch $GDB_COMMANDS"

kill $QEMU_PID 2>/dev/null
echo "Done"