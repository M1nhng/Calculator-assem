org 100h

.model small
.data

msg0:    db 0dh,0ah, " ___> Simple calculator <___" ,0dh,0ah,'$'                                                                                                           
msg:     db 0dh,0ah, "1-Add",0dh,0ah,"2-Multiply",0dh,0ah,"3-Subtract",0dh,0ah,"4-Divide", 0Dh,0Ah, '$' 
msg1:    db 0dh,0ah, "Enter a number between 1,4 if you want any calculation ::",0Dh,0Ah,'$'
msg2:    db 0dh,0ah, "Enter First No : $"
msg3:    db 0dh,0ah, "Enter Second No : $"
msg4:    db 0dh,0ah, "Choice Error....please Enter any key which is in range (1-4)", 0Dh,0Ah, "$"
msg5:    db 0dh,0ah, "Result : $" 
msg6:    db 0dh,0ah, "Thank you for using the calculator!", 0Dh,0Ah,'$'
msg7:    db 0dh,0ah, "Do you want to continue? (Y/N): $"

.code

start:
        mov ax, @data
        mov ds, ax

        mov ah,9
        mov dx, offset msg0 
        int 21h
                                          
        mov ah,9
        mov dx, offset msg 
        int 21h
        
        mov ah,9                  
        mov dx, offset msg1
        int 21h 
        
        mov ah,0                       
        int 16h  
        cmp al,31h  
        je Addition
        cmp al,32h
        je Multiply
        cmp al,33h
        je Subtract
        cmp al,34h
        je Divide

        mov ah,09h
        mov dx, offset msg4
        int 21h
        mov ah,0
        int 16h
        jmp start 

Addition:   
            mov ah,09h  
            mov dx, offset msg2  
            int 21h
            mov cx,0 
            call InputNo  
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call InputNo
            pop bx
            add dx,bx
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            call View 
            jmp ContinuePrompt

Multiply:   
            mov ah,09h
            mov dx, offset msg2
            int 21h
            mov cx,0
            call InputNo
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call InputNo
            pop bx
            mov ax,dx
            mul bx 
            mov dx,ax
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            call View 
            jmp ContinuePrompt

Subtract:   
            mov ah,09h
            mov dx, offset msg2
            int 21h
            mov cx,0
            call InputNo
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call InputNo
            pop bx
            sub bx,dx
            mov dx,bx
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            call View 
            jmp ContinuePrompt

Divide:     
            mov ah,09h
            mov dx, offset msg2
            int 21h
            mov cx,0
            call InputNo
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call InputNo
            pop bx
            mov ax,bx
            mov cx,dx
            mov dx,0
            mov bx,0
            div cx
            mov bx,dx
            mov dx,ax
            push bx 
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            call View
            pop bx
            jmp ContinuePrompt

InputNo:    
            mov ah,0
            int 16h 
            mov dx,0  
            mov bx,1 
            cmp al,0dh 
            je FormNo 
            sub ax,30h 
            call ViewNo 
            mov ah,0
            push ax  
            inc cx   
            jmp InputNo 

FormNo:     
            pop ax  
            push dx      
            mul bx
            pop dx
            add dx,ax
            mov ax,bx       
            mov bx,10
            push dx
            mul bx
            pop dx
            mov bx,ax
            dec cx
            cmp cx,0
            jne FormNo
            ret   
View:
    mov ax, dx
    mov bx, 10
    mov cx, 0
    mov si, 0        
    mov di, 0        

SaveDigits:
    xor dx, dx
    div bx
    push dx          
    inc si
    cmp ax, 0
    jne SaveDigits

PrintDigits:
    pop dx
    cmp dx, 0
    jne NotZero
    cmp di, 0
    je SkipZero
NotZero:
    add dl, '0'
    mov ah, 2
    int 21h
    mov di, 1
SkipZero:
    dec si
    cmp si, 0
    jne PrintDigits
    ret


ViewNo:     
            push ax
            push dx 
            mov dx,ax 
            add dl,30h 
            mov ah,2
            int 21h
            pop dx  
            pop ax
            ret

ContinuePrompt:
            mov ah,9
            mov dx, offset msg7
            int 21h

            mov ah,1
            int 21h
            cmp al, 'Y'
            je start
            cmp al, 'y'
            je start
            cmp al, 'N'
            je terminate
            cmp al, 'n'
            je terminate
            jmp ContinuePrompt

terminate:
            mov ah,9
            mov dx, offset msg6
            int 21h
            mov ah,0
            int 16h
            mov ah,4Ch
            int 21h

ret
