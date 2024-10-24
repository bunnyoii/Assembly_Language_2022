ASSUME CS:CODE,DS:DATA
DATA SEGMENT
 MSG1 DB 13,10,'Please input the num of Fibonacci, no larger than 256, N =  $'
 MSG2 DB 13,10,'Fibonacci Sequence is: $'    ; 提示信息
 
 N DW 0  
 F1  DW 1  ; 斐波那契数列的第一个数
 F2  DW 1  ; 斐波那契数列的第二个数
DATA ENDS

CODE SEGMENT
START:
 MOV AX,DATA
 MOV DS,AX  ; 导入数据段

 LEA DX,MSG1
 MOV AH,9
 INT 21H    ; 打印提示信息，要求输入 Fibonacci 序列长度

 CALL INPUT ; 调用输入模块，获取项数并存入 CX

 CMP CX,1    ; 如果 CX < 1，输入不合法
 JB EXIT     ; 输入非法，直接退出

 MOV N,CX     ; N = CX，即 N 为 Fibonacci 序列项数

 LEA DX,MSG2    ; 打印 "Fibonacci Sequence is:"
 MOV AH,9     
 INT 21H

; 处理第一个项
 MOV AX,F1   ; 输出第一个 Fibonacci 数字 1
 CALL OUTPUT ; 调用输出模块
 MOV DL,' '  ; 输出空格
 MOV AH,2
 INT 21H
 DEC N       ; N = N - 1
 JZ EXIT     ; 如果 N == 0，退出

; 处理第二个项
 MOV AX,F2   ; 输出第二个 Fibonacci 数字 1
 CALL OUTPUT ; 调用输出模块
 MOV DL,' '  
 MOV AH,2
 INT 21H
 DEC N       ; N = N - 1
 JZ EXIT     ; 如果 N == 0，退出

; 从第三个 Fibonacci 数开始循环计算和输出
LOOP:
    MOV AX,F1   ; AX = F1
    ADD AX,F2   ; AX = F1 + F2 计算新的 Fibonacci 数
    JC EXIT     ; 如果产生进位（数值过大），退出程序

    ; 更新 F1 和 F2 为下一个 Fibonacci 数的准备
    MOV BX,F2   ; 将 F2 保存到 BX
    MOV F1,BX   ; F1 = F2
    MOV F2,AX   ; F2 = 新计算的 Fibonacci 数

    CALL OUTPUT ; 输出新计算的 Fibonacci 数
    MOV DL,' '  
    MOV AH,2
    INT 21H     ; 输出空格
    DEC N       ; N = N - 1
    JNZ LOOP    ; 如果 N != 0，继续循环

EXIT:
 MOV AH,4CH
 INT 21H    ; 退出程序

; 输入模块，获取 Fibonacci 序列项数
INPUT:
 MOV BL,10     ; BL = 10，用于转换输入的 ASCII 数字
 MOV CX,0      ; CX = 0，初始化 Fibonacci 项数
 
IN_X:          ; 输入数字  
 MOV AH,7
 INT 21H       ; 读取输入字符
 
 CMP AL,13     ; 判断是否按下回车键
 JE IN_END     ; 如果是回车，结束输入
 
 CMP AL,'0'    ; 检查输入是否为有效数字
 JB IN_X       ; 如果输入不合法，继续输入
 CMP AL,'9'
 JA IN_X
 
 MOV DL,AL     ; 把合法数字存入 DL
 MOV AH,2      ; 输出刚输入的字符
 INT 21H
 SUB AL,30H    ; 转换 ASCII 数字为实际数字
 MOV AH,0      ; 清空 AH
 XCHG AX,CX    ; 把输入的数字存入 CX
 MUL BL        ; CX = CX * 10
 ADD CX,AX     ; CX = CX + 输入的数字

 CMP CX,256    ; 限制 Fibonacci 序列最大项数为 256
 JA IN_END     ; 如果 CX 超过 256，结束输入

 JMP IN_X      ; 否则继续输入

IN_END:
 RET           ; 返回调用

; 输出模块，将 AX 中的数转换为字符并输出
OUTPUT:
 MOV BX,10     ; BX = 10，除数
 MOV CX,0      ; CX = 0，用于计数
LOOP1:
    MOV DX,0    ; DX = 0，初始化余数
    DIV BX      ; AX 除以 10，余数放在 DX，商放在 AX
    ADD DL,'0'  ; 把余数转换为字符
    PUSH DX     ; 把转换后的字符压入栈
    INC CX      ; 计数增加
    CMP AX,0    ; 检查商是否为 0
    JNZ LOOP1   ; 如果商不为 0，继续循环

MOV AH,2       ; 准备输出字符
LOOP2:
    POP DX      ; 从栈中取出字符
    INT 21H     ; 输出字符
    LOOP LOOP2  ; 直到 CX == 0

RET            ; 返回调用

CODE ENDS
END START
