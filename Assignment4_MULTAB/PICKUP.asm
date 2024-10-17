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
    INT    21H                                       ; ��ʾ��ͷ
    MOV    CX, 9                                     ; ��ѭ��������
    MOV    AX, 1                                     ; �кų�ʼ��
    MOV    SI, 0                                     ; ������ʼ��

ROW_LOOP:
    PUSH   CX                                        ; �����ⲿѭ��������
    PUSH   AX                                        ; �����к�
    MOV    BX, 1                                     ; �кų�ʼ��
    MOV    CX, 9                                     ; ��ѭ��������

COLUMN_LOOP:
    XOR    DX, DX
    MOV    DL, multiplicationTable[SI]               ; ��ȡ����ֵ
    MUL    BL                                        ; AX = BX * BL (�к�)
    CMP    AX, DX                                    ; �Ƚϼ������ͱ���ֵ
    JNE    Handle_Error                             ; �����ͬ����ת��������
    JMP    Skip_Error                               ; �����ͬ������������

HANDLEERR:
    POP    DX                                       ; �ָ��к�
    PUSH   DX
    MOV    AL, DL                                   ; ��ֵתΪ ASCII
    ADD    AL, 30H
    MOV    AH, 02H
    MOV    DL, AL                                   ; ��ʾ����ֵ
    INT    21H
    LEA    DX, spaceSeparator
    MOV    AH, 09H
    INT    21H
    MOV    AL, BL                                   ; ��ʾ�к�
    ADD    AL, 30H
    MOV    DL, AL
    MOV    AH, 02H
    INT    21H
    LEA    DX, errorMessage
    MOV    AH, 09H
    INT    21H                                      ; ���������Ϣ

SKIPERR:
    POP    AX                                        ; �ָ��к�
    PUSH   AX                                        ; �����к�
    INC    BX                                        ; �к�����
    INC    SI                                        ; ָ���ƶ�����һ������
    LOOP   Column_Loop                               ; �ڲ�ѭ��

    POP    AX                                        ; �ָ��к�
    INC    AX                                        ; �к�����
    POP    CX                                        ; �ָ��ⲿѭ��������
    LOOP   Row_Loop                                  ; ���ѭ��

    MOV    AH, 4CH                                   ; ������������
    INT    21H

END START
