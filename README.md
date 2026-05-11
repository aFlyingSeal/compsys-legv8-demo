# compsys-demo

## Overview

This is where I save my source code for my computer system course. This exercise revolves around simple programming problems that requires using LEGv8.

I didn't have time to try out Linux or WSL and Github Codespaces happened to be the exact solution I was looking for when I needed to compile and run my source code.


## Repo Structure

```
compsys-legv8-demo/
├── README.md
├── .gitignore
└── src/
    ├── legv8   // LEGv8 programs
    └── x86     // x86 programs
```

## Compile And Run Your Source File:

LEGv8:

```bash
aarch64-linux-gnu-gcc -static src/legv8/filename.s -o bin/filename
qemu-aarch64 bin/filename   
```

x86:

```bash
nasm -f elf32 src/x86/filename.asm -o bin/filename.o
ld -m elf_i386 bin/filename.o -o bin/filename
bin/filename
```