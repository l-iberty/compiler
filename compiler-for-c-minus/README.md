# A very simple complier for `C-`

- `src/`下的代码用于词法和语法分析，支持完整的`C-`语言的词法和语法结构，但由于`C-`的函数参数列表的语法和`C`不同，因此我做了修改，详见[src/README.md](./src/README.md).
- `src-tac/`下的代码用于生成三地址码(在VSL框架上进行修改)，详见[src-tac/README.md](./src-tac/README.md).
- `src-asm/`下的代码用于生成x86汇编代码, 与之匹配的三地址码是`src-tac`，详见[src-asm/README.md](./src-asm/README.md).
- `src-tac2/` 目前较好的三地址码，参考了VSL，其中的所有代码由我编写调试，详见[src-tac2/README,md](src-tac2/README.md).
- `src-asm2/` 生成的汇编代码适应于`src-tac2`，相比于`src-asm`，只对文法中的个别产生式做了修改，详见[src-asm2/README.md](src-asm2/README.md)
