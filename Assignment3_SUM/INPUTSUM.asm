.MODEL SMALL                 ; ָ���ڴ�ģ��Ϊ SMALL
.STACK 100h                  ; ����ջ��СΪ 256 �ֽ� (100h)

.DATA
    prompt_msg  DB 'Input (1-100): $' ; ��ʾ�û�����1��100���ַ���
    sum_msg     DB 'Output: $'       ; ���������ַ���
    number      DW ?                 ; �洢�û����������
    sum         DW 0                 ; �洢�ۼӺͣ���ʼ��Ϊ0

.CODE
START:
    MOV AX, @DATA            ; �����ݶε�ַ���ص�AX�Ĵ�����
    MOV DS, AX               ; �����ݶε�ַ����DS�Ĵ���
    MOV ES, AX               ; �����ݶε�ַ����ES�Ĵ��� (δʹ��)
    LEA DX, prompt_msg       ; ������ʾ��Ϣ��ַ��DX�Ĵ���
    MOV AH, 09h              ; DOS���ܵ��ã���ʾ�ַ���
    INT 21h                  ; ִ��DOS�ж�21h����ʾ��ʾ��Ϣ
    XOR CX, CX               ; ����CX�Ĵ��������ڴ洢�û��������ֵ

READ_INPUT:
    MOV AH, 01h              ; DOS���ܵ��ã���ȡ���������ַ�
    INT 21h                  ; ִ��DOS�ж�21h����ȡ�ַ���AL�Ĵ���
    CMP AL, 0Dh              ; �Ƚ�AL�е��ַ��Ƿ�Ϊ�س�����0Dh��
    JE  CALCULATE_SUM        ; ����ǻس�������ת��CALCULATE_SUM�����ۼӼ���
    SUB AL, '0'              ; ���ַ�ת��Ϊ��ֵ (��ȥASCII�� '0')
    MOV BL, AL               ; ��ת�������ֵ�洢��BL��
    MOV AX, CX               ; ����ǰCX��ֵ����AX��
    MOV CX, 10               ; ����CXΪ10�����ڼ�����ֵλ��
    MUL CX                   ; AX = AX * 10��ʮ��������һλ
    ADD AX, BX               ; ���ϵ�ǰ���������
    MOV CX, AX               ; ����CXΪ�µ��ۻ�ֵ
    JMP READ_INPUT           ; ������ȡ��һ�������ַ�

CALCULATE_SUM:
    MOV AX, CX               ; ���û���������ִ���AX��
    MOV number, AX           ; ��AX��ֵ�洢������number��
    MOV CX, AX               ; ʹ��CX��Ϊ���������洢���������
    MOV BX, 1                ; ��ʼ��BXΪ1�����ڴ�1��ʼ�ۼ�
    XOR AX, AX               ; ����AX�������ۼӺ�

SUM_LOOP:
    CMP BX, number           ; �Ƚ�BX���û����������
    JA END_SUM_LOOP          ; ���BX�����û���������֣���ת��END_SUM_LOOP
    ADD AX, BX               ; ��BX��ֵ�ۼӵ�AX��
    INC BX                   ; BX��1
    JMP SUM_LOOP             ; ����ѭ���ۼ�

END_SUM_LOOP:
    MOV sum, AX              ; ���ۼӺʹ洢������sum��
    LEA DX, sum_msg          ; ���������Ϣ��ַ��DX�Ĵ���
    MOV AH, 09h              ; DOS���ܵ��ã���ʾ�ַ���
    INT 21h                  ; ִ��DOS�ж�21h����ʾ�����Ϣ
    MOV AX, sum              ; ���ۼӺʹ���AX�У�׼����ʾ
    CALL PRINT_DECIMAL       ; �����ӳ���PRINT_DECIMAL��ʾʮ������
    MOV AH, 4Ch              ; DOS���ܵ��ã���ֹ���򷵻ؿ���Ȩ������ϵͳ
    INT 21h                  ; ִ��DOS�ж�21h

PRINT_DECIMAL PROC
    PUSH AX                  ; ����AX��ֵ��ջ��
    PUSH BX                  ; ����BX��ֵ��ջ��
    PUSH CX                  ; ����CX��ֵ��ջ��
    PUSH DX                  ; ����DX��ֵ��ջ��
    XOR CX, CX               ; ����CX�����ڼ���
    MOV BX, 10               ; ����BXΪ10������ת��Ϊʮ����

CONVERT_LOOP:
    XOR DX, DX               ; ����DX����׼���洢����
    DIV BX                   ; AX����10������AX��������DX
    PUSH DX                  ; ������ѹ��ջ��
    INC CX                   ; ��������1
    CMP AX, 0                ; ������Ƿ�Ϊ0
    JNE CONVERT_LOOP         ; ����̲�Ϊ0������ѭ��

PRINT_LOOP:
    POP DX                   ; ��ջ�е�������
    ADD DL, '0'              ; ������ת��Ϊ�ַ�
    MOV AH, 02h              ; DOS���ܵ��ã���ʾ�����ַ�
    INT 21h                  ; ִ��DOS�ж�21h����ʾ�ַ�
    LOOP PRINT_LOOP          ; ѭ��CX�Σ���ӡ�����ַ�
    POP DX                   ; �ָ�DX��ֵ
    POP CX                   ; �ָ�CX��ֵ
    POP BX                   ; �ָ�BX��ֵ
    POP AX                   ; �ָ�AX��ֵ
    RET                      ; ���ص��õ�

PRINT_DECIMAL ENDP

END START                   ; �����������ڵ�ΪSTART