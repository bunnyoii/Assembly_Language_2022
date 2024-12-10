.MODEL SMALL
.STACK 100H
.DATA
    grid db '1','2','3','4','5','6','7','8','9' ; 井字棋网格
    player db 0                                  ; 当前玩家（1或2）
    win db 0                                     ; 胜利标志
    welcome db "Welcome to Tic-Tac-Toe' Game !!$"
    separator db " |---+---+---|$"
    rule db "Rule: You can move within locations 1 to 9.$"
    p1turnMessageX db "Player 1's (X) turn, which position do you want to choose?$"
    p2turnMessageO db "Player 2's (O) turn, which position do you want to choose?$"
    tieMessage db "The game tied between the two players!$"
    winMessage db "Congratulations!! The winner is Player $"
    sameDigitError db "ERROR! This place is taken.$"
    zeroError db "ERROR! Input is not a valid digit for the game.$"
    line db " *-----------*$"

.CODE
; --------------------- CODE Segment START -------------------------
; 定义子程序，用 PROC 和 ENDP 包含

; 打印字符串子程序
printString PROC
    mov ah, 09h        ; DOS 打印字符串服务
    int 21h
    ret
printString ENDP

; 打印单个字符子程序
printChar PROC
    push dx            ; 保存 DX 寄存器的值
    mov ah, 02h        ; DOS 打印字符服务
    int 21h
    pop dx             ; 恢复 DX 寄存器的值
    ret
printChar ENDP

; 打印新行子程序
newLine PROC
    mov dl, 0dh        ; 回车符
    mov ah, 02h
    int 21h
    mov dl, 0ah        ; 换行符
    mov ah, 02h
    int 21h
    ret
newLine ENDP

; 打印网格子程序
printGrid PROC
    LEA dx, line
    call printString
    call newLine
    LEA bx, grid
    call printRow
    LEA dx, separator
    call printString
    call newLine
    call printRow
    LEA dx, separator
    call printString
    call newLine
    call printRow
    LEA dx, line
    call printString
    call newLine
    ret
printGrid ENDP

; 打印一行网格内容子程序
printRow PROC
    ; 第一个单元格
    mov dl, ' '
    call printChar
    mov dl, '|'
    call printChar
    mov dl, ' '
    call printChar
    mov dl, [bx]
    call printChar
    mov dl, ' '
    call printChar
    mov dl, '|'
    call printChar
    inc bx
    ; 第二个单元格
    mov dl, ' '
    call printChar
    mov dl, [bx]
    call printChar
    mov dl, ' '
    call printChar
    mov dl, '|'
    call printChar
    inc bx
    ; 第三个单元格
    mov dl, ' '
    call printChar
    mov dl, [bx]
    call printChar
    mov dl, ' '
    call printChar
    mov dl, '|'
    call printChar
    inc bx
    call newLine
    ret
printRow ENDP

; 获取玩家输入的移动位置子程序
getMove PROC
    mov dl, ' '
    call printChar
    mov dl, '='
    call printChar
    mov dl, ' '
    call printChar
    mov ah, 01h        ; DOS 输入字符服务
    int 21h
    call checkValidDigit
    cmp ah, 1
    je contCheckTaken
    mov dl, 0dh
    call printChar
    LEA dx, zeroError
    call printString
    call newLine
    jmp getMove
contCheckTaken:
    LEA bx, grid
    sub al, '1'         ; 将字符转为索引
    mov ah, 0
    add bx, ax          ; 计算位置地址
    mov al, [bx]
    cmp al, '9'
    jng finishGetMove
    mov dl, 0dh
    call printChar
    LEA dx, sameDigitError
    call printString
    call newLine
    jmp getMove
finishGetMove:
    call newLine
    call newLine
    ret
getMove ENDP

; 检查输入的字符是否为有效数字子程序
checkValidDigit PROC
    mov ah, 0
    cmp al, '1'
    jl validDigit
    cmp al, '9'
    jg validDigit
    mov ah, 1
validDigit:
    ret
checkValidDigit ENDP

; 检查游戏是否有胜利者子程序
checkWin PROC
    LEA si, grid
    call checkDiagonal
    cmp win, 1
    je endCheckWin
    call checkRows
    cmp win, 1
    je endCheckWin
    call checkColumns
endCheckWin:
    ret
checkWin ENDP

; 检查对角线是否有相同符号子程序
checkDiagonal PROC
    ; 从左上到右下的对角线
    mov bx, si
    mov al, [bx]
    add bx, 4
    cmp al, [bx]
    jne diagonalRtL
    add bx, 4
    cmp al, [bx]
    jne diagonalRtL
    mov win, 1
    ret
diagonalRtL:
    ; 从右上到左下的对角线
    mov bx, si
    add bx, 2
    mov al, [bx]
    add bx, 2
    cmp al, [bx]
    jne endCheckDiagonal
    add bx, 2
    cmp al, [bx]
    jne endCheckDiagonal
    mov win, 1
endCheckDiagonal:
    ret
checkDiagonal ENDP

; 检查行是否有相同符号子程序
checkRows PROC
    ; 第一行
    mov bx, si
    mov al, [bx]
    inc bx
    cmp al, [bx]
    jne secondRow
    inc bx
    cmp al, [bx]
    jne secondRow
    mov win, 1
    ret
secondRow:
    ; 第二行
    mov bx, si
    add bx, 3
    mov al, [bx]
    inc bx
    cmp al, [bx]
    jne thirdRow
    inc bx
    cmp al, [bx]
    jne thirdRow
    mov win, 1
    ret
thirdRow:
    ; 第三行
    mov bx, si
    add bx, 6
    mov al, [bx]
    inc bx
    cmp al, [bx]
    jne endCheckRows
    inc bx
    cmp al, [bx]
    jne endCheckRows
    mov win, 1
endCheckRows:
    ret
checkRows ENDP

; 检查列是否有相同符号子程序
checkColumns PROC
    ; 第一列
    mov bx, si
    mov al, [bx]
    add bx, 3
    cmp al, [bx]
    jne secondColumn
    add bx, 3
    cmp al, [bx]
    jne secondColumn
    mov win, 1
    ret
secondColumn:
    ; 第二列
    mov bx, si
    inc bx
    mov al, [bx]
    add bx, 3
    cmp al, [bx]
    jne thirdColumn
    add bx, 3
    cmp al, [bx]
    jne thirdColumn
    mov win, 1
    ret
thirdColumn:
    ; 第三列
    mov bx, si
    add bx, 2
    mov al, [bx]
    add bx, 3
    cmp al, [bx]
    jne endCheckColumns
    add bx, 3
    cmp al, [bx]
    jne endCheckColumns
    mov win, 1
endCheckColumns:
    ret
checkColumns ENDP

; 主程序
MAIN PROC
    mov ax, @data
    mov ds, ax
    mov es, ax
    mov cx, 9          ; 最大移动次数
    mov player, 1      ; 初始化为玩家1
    LEA dx, welcome
    call printString
    call newLine
    LEA dx, rule
    call printString
    call newLine
    call newLine
gameLoop:
    ; 检查是否有胜利者
    call checkWin
    cmp win, 1
    je won
    ; 检查是否平局
    cmp cx, 0
    je tie
    ; 打印当前网格
    call printGrid
    ; 显示当前玩家的回合信息
    mov al, player
    cmp al, 1
    je p1turn
    jmp p2turn
p1turn:
    LEA dx, p1turnMessageX
    call printString
    call newLine
    jmp getMoveInput
p2turn:
    LEA dx, p2turnMessageO
    call printString
    call newLine
getMoveInput:
    call getMove
    ; 更新网格
    mov al, player
    cmp al, 1
    je setX
    mov dl, 'O'
    jmp updateGrid
setX:
    mov dl, 'X'
updateGrid:
    mov [bx], dl
    ; 检查是否有胜利者
    call checkWin
    cmp win, 1
    je won
    ; 切换玩家
    cmp player, 1
    je switchToP2
    mov player, 1
    jmp continueLoop
switchToP2:
    mov player, 2
continueLoop:
    ; 递减移动次数
    loop gameLoop

; 平局处理
tie:
    call newLine
    call printGrid
    call newLine
    LEA dx, tieMessage
    call printString
    jmp exit

; 胜利处理
won:
    call newLine
    call printGrid
    call newLine
    call newLine
    LEA dx, winMessage
    call printString
    mov dl, player
    add dl, '0'
    call printCharCOLOR
    call newLine
    jmp exit

; 退出程序
exit:
    mov ah, 4Ch        ; 退出程序
    int 21h
MAIN ENDP

END MAIN
