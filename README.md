# compsys-legv8-demo

## Overview

This is where I save my source code for my computer system course. This exercise revolves around simple programming problems that requires using LEGv8.

I didn't have time to try out Linux or WSL and Github Codespaces happened to be the exact solution I was looking for when I needed to compile and run my source code.


## Repo Structure

```
compsys-legv8-demo/
├── .gitignore
├── README.md
└── src/
    ├── Bai1.s
    ├── Bai2.s
    ├── Bai3.s
    ├── Bai4.s
    └── Bai5.s
```

## Compile And Run Your Source File:

```bash
cd src
aarch64-linux-gnu-gcc -static filename.s -o filename
qemu-aarch64 filename   
```
