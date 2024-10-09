.MODEL SMALL                 ; 指定内存模型为 SMALL
.STACK 100h                  ; 定义栈大小为 256 字节 (100h)

.DATA
    prompt_msg  DB 'Input (1-100): $' ; 提示用户输入1到100的字符串
    sum_msg     DB 'Output: $'       ; 输出结果的字符串
    number      DW ?                 ; 存储用户输入的数字
    sum         DW 0                 ; 存储累加和，初始化为0

.CODE
START:
    MOV AX, @DATA            ; 将数据段地址加载到AX寄存器中
    MOV DS, AX               ; 将数据段地址赋给DS寄存器
    MOV ES, AX               ; 将数据段地址赋给ES寄存器 (未使用)
    LEA DX, prompt_msg       ; 加载提示消息地址到DX寄存器
    MOV AH, 09h              ; DOS功能调用，显示字符串
    INT 21h                  ; 执行DOS中断21h，显示提示消息
    XOR CX, CX               ; 清零CX寄存器，用于存储用户输入的数值

READ_INPUT:
    MOV AH, 01h              ; DOS功能调用，读取键盘输入字符
    INT 21h                  ; 执行DOS中断21h，读取字符到AL寄存器
    CMP AL, 0Dh              ; 比较AL中的字符是否为回车符（0Dh）
    JE  CALCULATE_SUM        ; 如果是回车符，跳转到CALCULATE_SUM进行累加计算
    SUB AL, '0'              ; 将字符转换为数值 (减去ASCII码 '0')
    MOV BL, AL               ; 将转换后的数值存储到BL中
    MOV AX, CX               ; 将当前CX的值存入AX中
    MOV CX, 10               ; 设置CX为10，用于计算数值位移
    MUL CX                   ; AX = AX * 10，十进制左移一位
    ADD AX, BX               ; 加上当前输入的数字
    MOV CX, AX               ; 更新CX为新的累积值
    JMP READ_INPUT           ; 继续读取下一个输入字符

CALCULATE_SUM:
    MOV AX, CX               ; 将用户输入的数字存入AX中
    MOV number, AX           ; 将AX的值存储到变量number中
    MOV CX, AX               ; 使用CX作为计数器，存储输入的数字
    MOV BX, 1                ; 初始化BX为1，用于从1开始累加
    XOR AX, AX               ; 清零AX，用于累加和

SUM_LOOP:
    CMP BX, number           ; 比较BX和用户输入的数字
    JA END_SUM_LOOP          ; 如果BX大于用户输入的数字，跳转到END_SUM_LOOP
    ADD AX, BX               ; 将BX的值累加到AX中
    INC BX                   ; BX加1
    JMP SUM_LOOP             ; 继续循环累加

END_SUM_LOOP:
    MOV sum, AX              ; 将累加和存储到变量sum中
    LEA DX, sum_msg          ; 加载输出消息地址到DX寄存器
    MOV AH, 09h              ; DOS功能调用，显示字符串
    INT 21h                  ; 执行DOS中断21h，显示输出消息
    MOV AX, sum              ; 将累加和存入AX中，准备显示
    CALL PRINT_DECIMAL       ; 调用子程序PRINT_DECIMAL显示十进制数
    MOV AH, 4Ch              ; DOS功能调用，终止程序返回控制权给操作系统
    INT 21h                  ; 执行DOS中断21h

PRINT_DECIMAL PROC
    PUSH AX                  ; 保存AX的值到栈中
    PUSH BX                  ; 保存BX的值到栈中
    PUSH CX                  ; 保存CX的值到栈中
    PUSH DX                  ; 保存DX的值到栈中
    XOR CX, CX               ; 清零CX，用于计数
    MOV BX, 10               ; 设置BX为10，用于转换为十进制

CONVERT_LOOP:
    XOR DX, DX               ; 清零DX，以准备存储余数
    DIV BX                   ; AX除以10，商在AX，余数在DX
    PUSH DX                  ; 将余数压入栈中
    INC CX                   ; 计数器加1
    CMP AX, 0                ; 检查商是否为0
    JNE CONVERT_LOOP         ; 如果商不为0，继续循环

PRINT_LOOP:
    POP DX                   ; 从栈中弹出余数
    ADD DL, '0'              ; 将数字转换为字符
    MOV AH, 02h              ; DOS功能调用，显示单个字符
    INT 21h                  ; 执行DOS中断21h，显示字符
    LOOP PRINT_LOOP          ; 循环CX次，打印所有字符
    POP DX                   ; 恢复DX的值
    POP CX                   ; 恢复CX的值
    POP BX                   ; 恢复BX的值
    POP AX                   ; 恢复AX的值
    RET                      ; 返回调用点

PRINT_DECIMAL ENDP

END START                   ; 程序结束，入口点为START