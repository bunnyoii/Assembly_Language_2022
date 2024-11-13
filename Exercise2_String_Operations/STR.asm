.MODEL SMALL
.STACK 100h

.DATA
STRBUF DB 'ASASAASASSASASAASAS'
COUNT EQU $-STRBUF
STRING DB 'AS'
MESSG DB 'The Number of "AS" is: $'
NUM DB 0                     ; 用于存储 "AS" 的出现次数
NEWLINE DB 0AH, 0DH, '$'

.CODE
MAIN PROC
    MOV AX, @DATA            ; 初始化数据段
    MOV DS, AX
    MOV NUM, 0               ; 初始化计数器 NUM 为 0
    MOV CX, COUNT            ; 设置循环计数为字符串的长度
    MOV SI, OFFSET STRBUF    ; SI 指向 STRBUF 的开始
    MOV DI, OFFSET STRING    ; DI 指向 STRING ("AS")

CHECK_LOOP:
    MOV AL, [SI]             ; 比较 STRBUF 中当前字符和 STRING 的第一个字符
    CMP AL, [DI]
    JNE NEXT_CHAR            ; 如果不匹配，跳到下一个字符
    MOV AL, [SI + 1]         ; 比较 STRBUF 中的下一个字符和 STRING 的第二个字符
    CMP AL, [DI + 1]
    JNE NEXT_CHAR            ; 如果不匹配，跳到下一个字符
    INC NUM                  ; 如果匹配 "AS"，增加 NUM 计数

NEXT_CHAR:
    INC SI                   ; 指向 STRBUF 中的下一个字符
    LOOP CHECK_LOOP          ; 循环检查下一个字符

    ; 输出结果
    MOV AH, 09h              ; 显示提示信息
    LEA DX, MESSG
    INT 21h

    MOV AL, NUM              ; 将 NUM 的值传递给打印数字的子程序
    CALL PRINT_NUM

    ; 输出换行符
    MOV AH, 09h
    LEA DX, NEWLINE
    INT 21h

    ; 结束程序
    MOV AH, 4Ch
    INT 21h
MAIN ENDP

; 输出数字的子程序，支持输出 0-255 的数字
PRINT_NUM PROC
    MOV BX, 10               ; 设置除法基数为 10
    XOR CX, CX               ; 清空 CX，作为计数器
    MOV AH, 0                ; 清空 AH，准备进行除法

    ; 将 AL 转换为 ASCII
CONVERT_LOOP:
    XOR DX, DX               ; 清空 DX
    DIV BX                   ; AX / 10，商在 AX，余数在 DL
    ADD DL, '0'              ; 转换为 ASCII
    PUSH DX                  ; 压栈保存结果
    INC CX                   ; 增加位数计数
    TEST AX, AX              ; 检查商是否为 0
    JNZ CONVERT_LOOP         ; 如果商不为 0，继续转换

PRINT_DIGITS:
    POP DX                   ; 弹出栈顶的数字字符
    MOV AH, 02h              ; 显示字符的 DOS 功能
    MOV DL, DL               ; DL 中已含有 ASCII 字符
    INT 21h                  ; 显示字符
    LOOP PRINT_DIGITS        ; 循环显示直到栈为空
    RET
PRINT_NUM ENDP

END MAIN
