# 由三地址码生成x86汇编代码(2)

此版本和之前的[src-asm](../src-asm)相比，改动包括：

- 对[scanner.l](code/scanner.l)和[parser.y](code/parser.y)的规则段，以及文法中的个别产生式进行了细微修改，对原本的语义没有影响.
- 修改`main.c:insert_arg()`，将参数表达式插入到`arglist`末尾. 因为[src-tac2](../src-tac2)版本的三地址码在生成传参语句`arg xxx`时，已按照“从右到左”的顺序.

测试文件: [sample](./sample)