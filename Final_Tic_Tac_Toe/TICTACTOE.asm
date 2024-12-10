.MODEL SMALL
.STACK 100H
.DATA
    grid db '1','2','3','4','5','6','7','8','9' ; ����������
    player db 0                                  ; ��ǰ��ң�1��2��
    win db 0                                     ; ʤ����־
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
; �����ӳ����� PROC �� ENDP ����

; ��ӡ�ַ����ӳ���
printString PROC
    mov ah, 09h        ; DOS ��ӡ�ַ�������
    int 21h
    ret
printString ENDP

; ��ӡ�����ַ��ӳ���
printChar PROC
    push dx            ; ���� DX �Ĵ�����ֵ
    mov ah, 02h        ; DOS ��ӡ�ַ�����
    int 21h
    pop dx             ; �ָ� DX �Ĵ�����ֵ
    ret
printChar ENDP

; ��ӡ�����ӳ���
newLine PROC
    mov dl, 0dh        ; �س���
    mov ah, 02h
    int 21h
    mov dl, 0ah        ; ���з�
    mov ah, 02h
    int 21h
    ret
newLine ENDP

; ��ӡ�����ӳ���
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

; ��ӡһ�����������ӳ���
printRow PROC
    ; ��һ����Ԫ��
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
    ; �ڶ�����Ԫ��
    mov dl, ' '
    call printChar
    mov dl, [bx]
    call printChar
    mov dl, ' '
    call printChar
    mov dl, '|'
    call printChar
    inc bx
    ; ��������Ԫ��
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

; ��ȡ���������ƶ�λ���ӳ���
getMove PROC
    mov dl, ' '
    call printChar
    mov dl, '='
    call printChar
    mov dl, ' '
    call printChar
    mov ah, 01h        ; DOS �����ַ�����
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
    sub al, '1'         ; ���ַ�תΪ����
    mov ah, 0
    add bx, ax          ; ����λ�õ�ַ
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

; ���������ַ��Ƿ�Ϊ��Ч�����ӳ���
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

; �����Ϸ�Ƿ���ʤ�����ӳ���
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

; ���Խ����Ƿ�����ͬ�����ӳ���
checkDiagonal PROC
    ; �����ϵ����µĶԽ���
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
    ; �����ϵ����µĶԽ���
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

; ������Ƿ�����ͬ�����ӳ���
checkRows PROC
    ; ��һ��
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
    ; �ڶ���
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
    ; ������
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

; ������Ƿ�����ͬ�����ӳ���
checkColumns PROC
    ; ��һ��
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
    ; �ڶ���
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
    ; ������
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

; ������
MAIN PROC
    mov ax, @data
    mov ds, ax
    mov es, ax
    mov cx, 9          ; ����ƶ�����
    mov player, 1      ; ��ʼ��Ϊ���1
    LEA dx, welcome
    call printString
    call newLine
    LEA dx, rule
    call printString
    call newLine
    call newLine
gameLoop:
    ; ����Ƿ���ʤ����
    call checkWin
    cmp win, 1
    je won
    ; ����Ƿ�ƽ��
    cmp cx, 0
    je tie
    ; ��ӡ��ǰ����
    call printGrid
    ; ��ʾ��ǰ��ҵĻغ���Ϣ
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
    ; ��������
    mov al, player
    cmp al, 1
    je setX
    mov dl, 'O'
    jmp updateGrid
setX:
    mov dl, 'X'
updateGrid:
    mov [bx], dl
    ; ����Ƿ���ʤ����
    call checkWin
    cmp win, 1
    je won
    ; �л����
    cmp player, 1
    je switchToP2
    mov player, 1
    jmp continueLoop
switchToP2:
    mov player, 2
continueLoop:
    ; �ݼ��ƶ�����
    loop gameLoop

; ƽ�ִ���
tie:
    call newLine
    call printGrid
    call newLine
    LEA dx, tieMessage
    call printString
    jmp exit

; ʤ������
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

; �˳�����
exit:
    mov ah, 4Ch        ; �˳�����
    int 21h
MAIN ENDP

END MAIN
