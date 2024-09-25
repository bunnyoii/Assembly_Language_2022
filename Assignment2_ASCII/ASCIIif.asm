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

    MOV DX, 13

print_letters_conditional:
    MOV AH, 02h  
    MOV DL, [SI]                            
    INT 21h                                  

    INC SI                                  
    DEC CX                               
    JZ end_loop                              

    DEC DX                               
    CMP DX, 0                            
    JNE print_letters_conditional             

    MOV AH, 09h                             
    LEA DX, newline                        
    INT 21h                                  
    MOV DX, 13                           

    JMP print_letters_conditional    

end_loop:
    MOV AH, 09h
    LEA DX, newline
    INT 21h

    MOV AH, 4Ch                 
    INT 21h

MAIN ENDP
END MAIN
