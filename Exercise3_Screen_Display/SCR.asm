.MODEL SMALL
.STACK 100h

.DATA
    Hello DB '                               Tongji University$'  ; ��ʾ Tongji University

.CODE
START:
    MOV AX, @DATA           ; �����ݶε�ַ���� AX �Ĵ���
    MOV DS, AX              ; �����ݶε�ַ���� DS �Ĵ���
    MOV AX, 0B800H          ; ���Դ�ε�ַ����ɫ�ı�ģʽ������ AX
    MOV ES, AX              ; ���Դ�ε�ַ���� ES �Ĵ���

    CALL CLEAR_SCREEN       ; �����ӳ�������

    MOV SI, OFFSET Hello    ; �ַ�����ʼ��ַ���� SI
    MOV DI, 160 * 6         ; ������ʾλ��Ϊ�� 6 ��
    MOV CX, 48
    MOV BL, 1               ; �����ַ���ɫ����ɫ���� 1��
    CALL DISPLAY_STRING     ; �����ӳ�����ʾ�ַ���

    MOV SI, OFFSET Hello
    MOV DI, 160 * 7
    MOV CX, 48
    MOV BL, 2               ; �����ַ���ɫ����ɫ���� 2��
    CALL DISPLAY_STRING

    MOV SI, OFFSET Hello
    MOV DI, 160 * 8
    MOV CX, 48
    MOV BL, 3               ; �����ַ���ɫ����ɫ���� 3��
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

    MOV AX, 4C00h           ; ������������� DOS
    INT 21h                 ; �����ж��˳�

CLEAR_SCREEN PROC
    MOV DI, 0               ; �� DI ����Ϊ�Դ濪ʼλ��
    MOV CX, 4600            ; �Դ����� 2000 �֣�80*25����ÿ���� 2 �ֽڣ��� 4000 �ֽ�
    MOV AL, ' '             ; �ÿո��ַ������Ļ
    MOV AH, 0               ; ���ñ���ɫΪ��ɫ
    CLD                     ; ��������־���Ա������ַ

CLEAR_LOOP:
    STOSW                   ; �� AX �����ݣ��ַ�����ɫ�������Դ�
    LOOP CLEAR_LOOP         ; CX �� 1�������Ϊ 0������ѭ��
    RET                     ; ���ص����õ�

CLEAR_SCREEN ENDP

DISPLAY_STRING PROC
    PUSH AX                 ; ���� AX �Ĵ�����ֵ
    PUSH BX                 ; ���� BX �Ĵ�����ֵ

DISPLAY_LOOP:
    MOV AL, [SI]            ; ���ַ�����ȡ��һ���ַ�
    MOV ES:[DI], AL         ; ���ַ�д���Դ�
    MOV ES:[DI+1], BL       ; ����ɫֵд���Դ�
    INC SI                  ; SI ָ����һ���ַ�
    ADD DI, 2               ; DI ָ���Դ����һ���ַ�λ�ã�ÿ�ַ�ռ 2 �ֽڣ�
    LOOP DISPLAY_LOOP       ; CX �� 1�������Ϊ 0������ѭ��
    POP BX                  ; �ָ� BX �Ĵ�����ֵ
    POP AX                  ; �ָ� AX �Ĵ�����ֵ
    RET                     ; ���ص����õ�

DISPLAY_STRING ENDP

END START
