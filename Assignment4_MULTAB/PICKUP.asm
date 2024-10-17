.MODEL SMALL
.STACK 100h

.DATA
    multiplicationTable db 7,2,3,4,5,6,7,8,9
                      db 2,4,7,8,10,12,14,16,18
                      db 3,6,9,12,15,18,21,24,27
                      db 4,8,12,16,7,24,28,32,36
                      db 5,10,15,20,25,30,35,40,45
                      db 6,12,18,24,30,7,42,48,54
                      db 7,14,21,28,35,42,49,56,63 
                      db 8,16,24,32,40,48,56,7,72 
                      db 9,18,27,36,45,54,63,72,81    
    outputHeader db "x  y", 0DH, 0AH, '$'
    spaceSeparator db "  ", '$'
    errorMessage db "  error", 0DH, 0AH, '$'
    lineEnd db 0DH, 0AH, '$'

.CODE
START:
    MOV    AX, @DATA
    MOV    DS, AX
    LEA    DX, outputHeader
    MOV    AH, 09H
    INT    21H                                       ; 显示表头
    MOV    CX, 9                                     ; 行循环计数器
    MOV    AX, 1                                     ; 行号初始化
    MOV    SI, 0                                     ; 索引初始化

ROW_LOOP:
    PUSH   CX                                        ; 保存外部循环计数器
    PUSH   AX                                        ; 保存行号
    MOV    BX, 1                                     ; 列号初始化
    MOV    CX, 9                                     ; 列循环计数器

COLUMN_LOOP:
    XOR    DX, DX
    MOV    DL, multiplicationTable[SI]               ; 读取表中值
    MUL    BL                                        ; AX = BX * BL (列号)
    CMP    AX, DX                                    ; 比较计算结果和表中值
    JNE    Handle_Error                             ; 如果不同，跳转到错误处理
    JMP    Skip_Error                               ; 如果相同，跳过错误处理

HANDLEERR:
    POP    DX                                       ; 恢复列号
    PUSH   DX
    MOV    AL, DL                                   ; 将值转为 ASCII
    ADD    AL, 30H
    MOV    AH, 02H
    MOV    DL, AL                                   ; 显示错误值
    INT    21H
    LEA    DX, spaceSeparator
    MOV    AH, 09H
    INT    21H
    MOV    AL, BL                                   ; 显示列号
    ADD    AL, 30H
    MOV    DL, AL
    MOV    AH, 02H
    INT    21H
    LEA    DX, errorMessage
    MOV    AH, 09H
    INT    21H                                      ; 输出错误消息

SKIPERR:
    POP    AX                                        ; 恢复行号
    PUSH   AX                                        ; 保持行号
    INC    BX                                        ; 列号自增
    INC    SI                                        ; 指针移动到下一个表项
    LOOP   Column_Loop                               ; 内层循环

    POP    AX                                        ; 恢复行号
    INC    AX                                        ; 行号自增
    POP    CX                                        ; 恢复外部循环计数器
    LOOP   Row_Loop                                  ; 外层循环

    MOV    AH, 4CH                                   ; 正常结束程序
    INT    21H

END START
