.MODEL SMALL
.STACK 100h

.DATA
STRBUF DB 'ASASAASASSASASAASAS'
COUNT EQU $-STRBUF
STRING DB 'AS'
MESSG DB 'The Number of "AS" is: $'
NUM DB 0                     ; ���ڴ洢 "AS" �ĳ��ִ���
NEWLINE DB 0AH, 0DH, '$'

.CODE
MAIN PROC
    MOV AX, @DATA            ; ��ʼ�����ݶ�
    MOV DS, AX
    MOV NUM, 0               ; ��ʼ�������� NUM Ϊ 0
    MOV CX, COUNT            ; ����ѭ������Ϊ�ַ����ĳ���
    MOV SI, OFFSET STRBUF    ; SI ָ�� STRBUF �Ŀ�ʼ
    MOV DI, OFFSET STRING    ; DI ָ�� STRING ("AS")

CHECK_LOOP:
    MOV AL, [SI]             ; �Ƚ� STRBUF �е�ǰ�ַ��� STRING �ĵ�һ���ַ�
    CMP AL, [DI]
    JNE NEXT_CHAR            ; �����ƥ�䣬������һ���ַ�
    MOV AL, [SI + 1]         ; �Ƚ� STRBUF �е���һ���ַ��� STRING �ĵڶ����ַ�
    CMP AL, [DI + 1]
    JNE NEXT_CHAR            ; �����ƥ�䣬������һ���ַ�
    INC NUM                  ; ���ƥ�� "AS"������ NUM ����

NEXT_CHAR:
    INC SI                   ; ָ�� STRBUF �е���һ���ַ�
    LOOP CHECK_LOOP          ; ѭ�������һ���ַ�

    ; ������
    MOV AH, 09h              ; ��ʾ��ʾ��Ϣ
    LEA DX, MESSG
    INT 21h

    MOV AL, NUM              ; �� NUM ��ֵ���ݸ���ӡ���ֵ��ӳ���
    CALL PRINT_NUM

    ; ������з�
    MOV AH, 09h
    LEA DX, NEWLINE
    INT 21h

    ; ��������
    MOV AH, 4Ch
    INT 21h
MAIN ENDP

; ������ֵ��ӳ���֧����� 0-255 ������
PRINT_NUM PROC
    MOV BX, 10               ; ���ó�������Ϊ 10
    XOR CX, CX               ; ��� CX����Ϊ������
    MOV AH, 0                ; ��� AH��׼�����г���

    ; �� AL ת��Ϊ ASCII
CONVERT_LOOP:
    XOR DX, DX               ; ��� DX
    DIV BX                   ; AX / 10������ AX�������� DL
    ADD DL, '0'              ; ת��Ϊ ASCII
    PUSH DX                  ; ѹջ������
    INC CX                   ; ����λ������
    TEST AX, AX              ; ������Ƿ�Ϊ 0
    JNZ CONVERT_LOOP         ; ����̲�Ϊ 0������ת��

PRINT_DIGITS:
    POP DX                   ; ����ջ���������ַ�
    MOV AH, 02h              ; ��ʾ�ַ��� DOS ����
    MOV DL, DL               ; DL ���Ѻ��� ASCII �ַ�
    INT 21h                  ; ��ʾ�ַ�
    LOOP PRINT_DIGITS        ; ѭ����ʾֱ��ջΪ��
    RET
PRINT_NUM ENDP

END MAIN
