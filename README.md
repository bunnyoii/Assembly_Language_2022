# Assembly_Language_2022
同济大学 2022级 计算机科学与技术学院 软件工程专业 嵌入式系统方向 汇编语言课程作业

授课教师：王冬青

授课学期：2024-2025年度 秋季学期

## 项目构成

### helloworld (2024/9/24)
1. 传统方式：源代码->汇编->链接（会用debug -u反汇编查看机器码和源代码之间的关系），提交源代码和exe文件
2. 另类方式：直接将代码和数据用debug -e写到内存中去执行

### ASCII (2024/9/25)
1. 用 loop 指今实现
2. 用条件跳转指令实现
3. 用C语言实现后察看反汇编代码并加注释

### SUM (2024/10/8)
1. 求 1+2+...+100，并将结果5050打印到屏幕上
2. 注意和的结果数据表示范围，结果的进制转换等问题。
  - 尝试结果放在寄存器中、放在数据段中，放在栈中等不同位置的操作；
  - 用户输入 1~100 内的任何一个数，完成十进制结果输出。(查找 21号中断的功能表，找到输入数据的功能调用)；
  - 用C语言实现后察看反汇编代码并加注释。

### MULTAB (2024/10/17)
1. 输出九九乘法表：要求至少实现一个过程调用，能正确调用并返回。
2. 九九乘法表纠错：检查 9*9乘法表内数据是否正确,将不正确位置确定下来并显示在屏幕上。

### SALARY（2024/11/13）
工资计算

## 文档更新日期
2024年11月13日
