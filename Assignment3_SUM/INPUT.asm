.MODEL SMALL
.STACK 100h

.DATA
    InputBuffer DB 10, 0 ; 输入缓冲区大小，第二个字节初始为0
    DB 10 DUP(0)         ; 分配10个字节的空间来存放用户输入的字符
    Msg DB 'You entered: $' ; 提示消息
    Number DB 3 DUP(0)   ; 用于存储用户输入的数字（最多3位数）

.CODE
START:
    MOV AX, @DATA        ; 初始化数据段
    MOV DS, AX

    ; 输入字符
    MOV DX, OFFSET InputBuffer ; 将缓冲区地址放入 DX
    MOV AH, 0AH           ; 使用功能号 0AH 读取字符串
    INT 21H               ; 调用 DOS 中断

    ; 输出结果前，清零 Number 数组
    MOV DI, OFFSET Number ; DI 指向 Number 数组
    MOV CX, 0             ; 计数器

    ; 将输入的字符转换为十进制数字
    MOV CL, [InputBuffer + 1] ; 获取输入的字符数量
    MOV SI, OFFSET InputBuffer + 2 ; SI 指向输入字符开始的位置

ConvertLoop:
    ; 检查输入字符的数量
    CMP CX, 0              ; 如果 CX <= 0，结束转换
    JE OutputResult

    ; 将字符转换为数字
    MOV AL, [SI]           ; 读取当前字符
    SUB AL, '0'            ; 转换为数字
    MOV [DI], AL           ; 存储数字
    INC DI                 ; 移动到下一个存储位置
    INC SI                 ; 移动到下一个输入字符
    DEC CX                 ; 减少字符计数
    JMP ConvertLoop

OutputResult:
    ; 输出结果
    MOV AH, 09H            ; 准备输出字符串
    MOV DX, OFFSET Msg      ; 将消息地址放入 DX
    INT 21H                 ; 输出提示消息

    ; 重新准备输出数字
    MOV DI, OFFSET Number   ; DI 指向 Number 数组
    MOV CL, [InputBuffer + 1] ; 获取输入的字符数量

PrintLoop:
    CMP CL, 0              ; 检查是否还有字符要输出
    JE EndProgram          ; 如果没有，结束程序

    ; 转换数字回字符并输出
    MOV AL, [DI]           ; 读取数字
    ADD AL, '0'            ; 转换为字符
    MOV DL, AL             ; 将字符放入 DL
    MOV AH, 02H            ; 准备输出字符
    INT 21H                ; 输出字符

    INC DI                 ; 移动到下一个数字
    DEC CL                 ; 减少字符计数
    JMP PrintLoop          ; 继续输出

EndProgram:
    ; 结束程序
    MOV AX, 4C00h          ; 退出程序
    INT 21H

END START
