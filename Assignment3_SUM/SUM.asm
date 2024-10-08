.MODEL SMALL   ; 定义小型模型
.STACK 100h    ; 设置堆栈大小为 256 字节

.DATA           ; 数据段开始
    I DB ?      ; 用于存储结果
    Result DB ? ; 用于存储计算结果

.CODE           ; 代码段开始
START:          
    MOV AX, @DATA  ; 将数据段地址加载到 AX
    MOV DS, AX     ; 初始化数据段寄存器
    MOV CX, 100    ; CX = 100
    MOV AX, 0      ; AX = 0

; --------------------------
; 将结果放在寄存器中
; --------------------------
A1: 
    ADD AX, CX     ; AX += CX
    LOOP A1        ; CX -= 1，循环直到 CX = 0

; 保存结果在寄存器中（AX）
    ; 这里可以直接使用 AX，AX 的值是我们计算的结果

; --------------------------
; 将结果放在数据段中
; --------------------------
    MOV Result, AL ; 将 AL 的值存入数据段变量 Result

; --------------------------
; 将结果放在栈中
; --------------------------
    PUSH AX        ; 将 AX 压入堆栈

    MOV CX, 10     ; CX = 10
    MOV BX, 10000  ; BX = 10000

A2: 
    XOR DX, DX     ; 清零 DX
    MOV AX, BX     ; AX = BX
    DIV CX         ; AX 除以 CX，结果在 AX，余数在 DX
    CMP AX, 0      ; 比较 AX 和 0
    JL S           ; 如果 AX < 0，跳转到 S
    JE S           ; 如果 AX = 0，跳转到 S
    
    MOV BX, AX     ; 将 AX 的值存入 BX
    XOR DX, DX     ; 清零 DX
    POP AX         ; 从堆栈弹出 AX
    DIV BX         ; AX 除以 BX
    PUSH DX        ; 将余数推入栈
    ADD AL, 30H    ; 将 AL 转换为 ASCII
    MOV DL, AL     ; DL = AL
    MOV AH, 2      ; 准备调用 DOS 打印字符
    INT 21H        ; 调用 DOS 中断打印字符
    JMP A2         ; 跳回 A2

S:    
    MOV AH, 4CH    ; 结束程序
    INT 21H        ; 调用 DOS 中断退出程序

END START        ; 程序结束
