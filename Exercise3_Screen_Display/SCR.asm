.MODEL SMALL
.STACK 100h

.DATA
    Hello DB '                               Tongji University$'  ; 显示 Tongji University

.CODE
START:
    MOV AX, @DATA           ; 将数据段地址载入 AX 寄存器
    MOV DS, AX              ; 将数据段地址载入 DS 寄存器
    MOV AX, 0B800H          ; 将显存段地址（彩色文本模式）载入 AX
    MOV ES, AX              ; 将显存段地址载入 ES 寄存器

    CALL CLEAR_SCREEN       ; 调用子程序清屏

    MOV SI, OFFSET Hello    ; 字符串起始地址载入 SI
    MOV DI, 160 * 6         ; 设置显示位置为第 6 行
    MOV CX, 48
    MOV BL, 1               ; 设置字符颜色（颜色代码 1）
    CALL DISPLAY_STRING     ; 调用子程序显示字符串

    MOV SI, OFFSET Hello
    MOV DI, 160 * 7
    MOV CX, 48
    MOV BL, 2               ; 设置字符颜色（颜色代码 2）
    CALL DISPLAY_STRING

    MOV SI, OFFSET Hello
    MOV DI, 160 * 8
    MOV CX, 48
    MOV BL, 3               ; 设置字符颜色（颜色代码 3）
    CALL DISPLAY_STRING

    MOV SI, OFFSET Hello
    MOV DI, 160 * 9
    MOV CX, 48
    MOV BL, 4
    CALL DISPLAY_STRING

    MOV SI, OFFSET Hello
    MOV DI, 160 * 10
    MOV CX, 48
    MOV BL, 5
    CALL DISPLAY_STRING

    MOV SI, OFFSET Hello
    MOV DI, 160 * 11
    MOV CX, 48
    MOV BL, 6
    CALL DISPLAY_STRING

    MOV SI, OFFSET Hello
    MOV DI, 160 * 12
    MOV CX, 48
    MOV BL, 7
    CALL DISPLAY_STRING

    MOV SI, OFFSET Hello
    MOV DI, 160 * 13
    MOV CX, 48
    MOV BL, 8
    CALL DISPLAY_STRING

    MOV SI, OFFSET Hello
    MOV DI, 160 * 14
    MOV CX, 48
    MOV BL, 9
    CALL DISPLAY_STRING

    MOV SI, OFFSET Hello
    MOV DI, 160 * 15
    MOV CX, 48
    MOV BL, 10
    CALL DISPLAY_STRING

    MOV SI, OFFSET Hello
    MOV DI, 160 * 16
    MOV CX, 48
    MOV BL, 11
    CALL DISPLAY_STRING

    MOV SI, OFFSET Hello
    MOV DI, 160 * 17
    MOV CX, 48
    MOV BL, 12
    CALL DISPLAY_STRING

    MOV SI, OFFSET Hello
    MOV DI, 160 * 18
    MOV CX, 48
    MOV BL, 13
    CALL DISPLAY_STRING

    MOV SI, OFFSET Hello
    MOV DI, 160 * 19
    MOV CX, 48
    MOV BL, 14
    CALL DISPLAY_STRING

    MOV SI, OFFSET Hello
    MOV DI, 160 * 20
    MOV CX, 48
    MOV BL, 15
    CALL DISPLAY_STRING

    MOV AX, 4C00h           ; 程序结束，返回 DOS
    INT 21h                 ; 调用中断退出

CLEAR_SCREEN PROC
    MOV DI, 0               ; 将 DI 设置为显存开始位置
    MOV CX, 4600            ; 显存区域共 2000 字（80*25），每个字 2 字节，共 4000 字节
    MOV AL, ' '             ; 用空格字符填充屏幕
    MOV AH, 0               ; 设置背景色为黑色
    CLD                     ; 清除方向标志，以便递增地址

CLEAR_LOOP:
    STOSW                   ; 将 AX 的内容（字符和颜色）存入显存
    LOOP CLEAR_LOOP         ; CX 减 1，如果不为 0，继续循环
    RET                     ; 返回到调用点

CLEAR_SCREEN ENDP

DISPLAY_STRING PROC
    PUSH AX                 ; 保存 AX 寄存器的值
    PUSH BX                 ; 保存 BX 寄存器的值

DISPLAY_LOOP:
    MOV AL, [SI]            ; 从字符串中取出一个字符
    MOV ES:[DI], AL         ; 将字符写入显存
    MOV ES:[DI+1], BL       ; 将颜色值写入显存
    INC SI                  ; SI 指向下一个字符
    ADD DI, 2               ; DI 指向显存的下一个字符位置（每字符占 2 字节）
    LOOP DISPLAY_LOOP       ; CX 减 1，如果不为 0，继续循环
    POP BX                  ; 恢复 BX 寄存器的值
    POP AX                  ; 恢复 AX 寄存器的值
    RET                     ; 返回到调用点

DISPLAY_STRING ENDP

END START
