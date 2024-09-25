.MODEL SMALL
.STACK 100h
.DATA
    letters DB 'abcdefghijklmnopqrstuvwxyz$'
    newline DB 0Dh, 0Ah, '$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV CX, 26
    LEA SI, letters

outer_loop:
    PUSH CX
    MOV CX, 13

print_letters_loop:
    MOV AH, 02h
    MOV DL, [SI]
    INT 21h
    INC SI
    LOOP print_letters_loop

    MOV AH, 09h
    LEA DX, newline
    INT 21h

    POP CX
    SUB CX, 13
    JNZ outer_loop

    MOV AH, 4Ch
    INT 21h

MAIN ENDP
END MAIN
