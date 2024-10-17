DATA SEGMENT
    RES DB 3 DUP(0)
    PR DB 00H, '*', 00H, '=', 2 DUP(2), ' ', '$' ; 结果
    LINE DB 0DH, 0AH, '$'   ; 换行
    IPP DW 0000H             ; 主程序地址
DATA ENDS

STACK SEGMENT
    DB 20 DUP(0)            ; 栈空间
STACK ENDS

CODE SEGMENT
ASSUME CS:CODE, DS:DATA, SS:STACK

START: 
    MOV AX, DATA
    MOV DS, AX
    MOV CX, 9               ; 行数（九九乘法表9行）
    
; 行循环
L1: 
    MOV DH, 0AH             ; DH存储当前行最大列数
    SUB DH, CL              ; DH = 当前行最大列数 - 行数
    MOV DL, 01H             ; DL存储当前列数
    MOV AL, DH              ; AL = 当前行的最大乘数
    AND AX, 00FFH           ; 清除高位

; 列循环
L2: 
    CMP DL, DH              ; 比较当前列数与最大列数
    JA NEXT                 ; 如果当前列数 > 最大列数，跳到 NEXT
    PUSH DX                 ; 保存当前列数
    PUSH CX                 ; 保存当前行数
    PUSH AX                 ; 保存被乘数
    PUSH DX                 ; 保存乘数
    MOV AL, DH              ; AL = 当前行最大乘数
    MUL DL                  ; 乘法运算，结果在 AX 中
    PUSH AX                 ; 保存结果
    CALL NUM                ; 调用输出过程
    POP CX                  ; 恢复当前行数
    POP DX                  ; 恢复当前列数
    INC DL                  ; 当前列数 +1
    JMP L2                  ; 跳回列循环

NEXT: 
    MOV DX, OFFSET LINE     ; 换行
    MOV AH, 09H
    INT 21H                 ; 调用 DOS 功能
    LOOP L1                 ; 行循环

    MOV AH, 4CH             ; 结束程序
    INT 21H

NUM PROC
    POP IPP                 ; 恢复主函数地址
    POP DX                  ; 恢复结果
    MOV AX, DX              ; 结果存入 AX
    MOV BL, 0AH             ; 除数 10
    DIV BL                  ; 除法，结果在 AX 中，余数在 DX 中
    ADD AX, 3030H           ; 转换为 ASCII
    MOV PR+4, AL            ; 存储十位
    MOV PR+5, AH            ; 存储个位
    POP AX                  ; 恢复乘数
    AND AL, 0FH             ; 保留低4位
    ADD AL, 30H             ; 转换为 ASCII
    MOV PR+2, AL            ; 存储乘数
    POP AX                  ; 恢复被乘数
    AND AL, 0FH             ; 保留低4位
    ADD AL, 30H             ; 转换为 ASCII
    MOV PR, AL              ; 存储被乘数

    ; 输出结果
    MOV DX, OFFSET PR       ; 结果地址
    MOV AH, 09H
    INT 21H                 ; 调用 DOS 功能
    PUSH IPP                ; 恢复主函数地址
    RET  
NUM ENDP

CODE ENDS
END START
