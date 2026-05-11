# compsys-demo

## Overview

This is where I save my source code for my computer system course. This exercise revolves around simple programming problems that requires using LEGv8.

I didn't have time to try out Linux or WSL and Github Codespaces happened to be the exact solution I was looking for when I needed to compile and run my source code.


## Repo Structure

```
compsys-demo/
├── README.md
├── .gitignore
└── src/
    └── legv8   // LEGv8 programs
    └── x86     // x86 programs
```

## Compile And Run Your Source File:

LEGv8:

```bash
cd src
aarch64-linux-gnu-gcc -static filename.s -o filename
qemu-aarch64 filename   
```

x86:

```bash

```