DATA SEGMENT
    RES DB 3 DUP(0)
    PR DB 00H, '*', 00H, '=', 2 DUP(2), ' ', '$' ; ���
    LINE DB 0DH, 0AH, '$'   ; ����
    IPP DW 0000H             ; �������ַ
DATA ENDS

STACK SEGMENT
    DB 20 DUP(0)            ; ջ�ռ�
STACK ENDS

CODE SEGMENT
ASSUME CS:CODE, DS:DATA, SS:STACK

START: 
    MOV AX, DATA
    MOV DS, AX
    MOV CX, 9               ; �������žų˷���9�У�
    
; ��ѭ��
L1: 
    MOV DH, 0AH             ; DH�洢��ǰ���������
    SUB DH, CL              ; DH = ��ǰ��������� - ����
    MOV DL, 01H             ; DL�洢��ǰ����
    MOV AL, DH              ; AL = ��ǰ�е�������
    AND AX, 00FFH           ; �����λ

; ��ѭ��
L2: 
    CMP DL, DH              ; �Ƚϵ�ǰ�������������
    JA NEXT                 ; �����ǰ���� > ������������� NEXT
    PUSH DX                 ; ���浱ǰ����
    PUSH CX                 ; ���浱ǰ����
    PUSH AX                 ; ���汻����
    PUSH DX                 ; �������
    MOV AL, DH              ; AL = ��ǰ��������
    MUL DL                  ; �˷����㣬����� AX ��
    PUSH AX                 ; ������
    CALL NUM                ; �����������
    POP CX                  ; �ָ���ǰ����
    POP DX                  ; �ָ���ǰ����
    INC DL                  ; ��ǰ���� +1
    JMP L2                  ; ������ѭ��

NEXT: 
    MOV DX, OFFSET LINE     ; ����
    MOV AH, 09H
    INT 21H                 ; ���� DOS ����
    LOOP L1                 ; ��ѭ��

    MOV AH, 4CH             ; ��������
    INT 21H

NUM PROC
    POP IPP                 ; �ָ���������ַ
    POP DX                  ; �ָ����
    MOV AX, DX              ; ������� AX
    MOV BL, 0AH             ; ���� 10
    DIV BL                  ; ����������� AX �У������� DX ��
    ADD AX, 3030H           ; ת��Ϊ ASCII
    MOV PR+4, AL            ; �洢ʮλ
    MOV PR+5, AH            ; �洢��λ
    POP AX                  ; �ָ�����
    AND AL, 0FH             ; ������4λ
    ADD AL, 30H             ; ת��Ϊ ASCII
    MOV PR+2, AL            ; �洢����
    POP AX                  ; �ָ�������
    AND AL, 0FH             ; ������4λ
    ADD AL, 30H             ; ת��Ϊ ASCII
    MOV PR, AL              ; �洢������

    ; ������
    MOV DX, OFFSET PR       ; �����ַ
    MOV AH, 09H
    INT 21H                 ; ���� DOS ����
    PUSH IPP                ; �ָ���������ַ
    RET  
NUM ENDP

CODE ENDS
END START
