INCLUDE EMU8086.INC     ;Including Library

org 100h

.data       ;Data Segment

msg_intro db '  1. Addition', 0dh,0ah, '  2. Subtraction', 0dh,0ah, '  3. Multiplication', 0dh,0ah, '  4. Division', 0dh,0ah, '  5. Negation', 0dh,0ah, '  6. Square', 0dh,0ah, '  7. Cube', 0dh,0ah, '  8. OR', 0dh,0ah, '  9. AND', 0dh,0ah, ' 10. XOR', 0dh,0ah, ' 11. NOT', 0dh,0ah, ' 12. Modulus', 0dh,0ah, ' 13. Rotate Left', 0dh,0ah, ' 14. Rotate Right', 0dh,0ah, '  0. EXIT', '$'

msg_A db 'The SUM of two Numbers = $', 0dh,0ah
msg_S db 'The SUBTRACTION of two Numbers = $', 0dh,0ah
msg_M db 'The MULTIPLICATION of two Numbers = $', 0dh,0ah
msg_D db 'The DIVISION of two Numbers = $', 0dh,0ah
msg_N db 'The NEG value of Number = $', 0dh,0ah
msg_SQ db 'The SQUARE of Number = $', 0dh,0ah
msg_CB db 'The CUBE of Number = $', 0dh,0ah
msg_OR db 'The OR operation of two Numbers = $', 0dh,0ah
msg_AND db 'The AND operation of two Numbers = $', 0dh,0ah
msg_XOR db 'The XOR operation of two Numbers = $', 0dh,0ah
msg_NOT db 'The NOT of Number = $', 0dh,0ah
msg_MD db 'The MODULUS of Two Numbers = $', 0dh,0ah
msg_RL db 'The Rotate Left of Number = $', 0dh,0ah
msg_RR db 'The Rotate Right of Number = $', 0dh,0ah

cont db 10,13,'Do you want to Use Again? $'
bye db '            **** Thank You !!!  :) **** $'

val1 dw ?       ;Uninitialize
val2 dw ?       ;Uninitialize  
res dw ?
agn dw ?

.code       ;Code Segment
MAIN PROC
    
MOV AX, @data
MOV DS, AX

Start:                  ;Start Label

print '             **** CALCULATOR ****    '  
printn      ;New Line

printn
MOV AH,9
MOV DX, OFFSET msg_intro
INT 21h                                          ; Display the options list

printn
printn
print 'Select Any Option : '
CALL scan_num           ; Read the option
printn
printn

CMP CX, 0
JE _Bye                 ; Jump to exit

CMP CX, 1
JE Addition             ; Jump to Addition

CMP CX, 2
JE Subtraction          ; Jump to Subtraction

CMP CX, 3
JE Multiplication       ; Jump to Multiplication

CMP CX, 4
JE Division             ; Jump to Division

CMP CX, 5
JE Negation             ; Jump to Negation

CMP CX, 6
JE Square               ; Jump to Square

CMP CX, 7
JE Cube                 ; Jump to Cube

CMP CX, 8
JE _OR                  ; Jump to OR

CMP CX, 9
JE _AND                 ; Jump to AND

CMP CX, 10
JE _XOR                 ; Jump to XOR

CMP CX, 11
JE _NOT                 ; Jump to NOT

CMP CX, 12
JE Modulus              ; Jump to Modulus

CMP CX, 13
JE Rotate_Left          ; Jump to Rotate Left

CMP CX, 14
JE Rotate_Right         ; Jump to Rotate Right

; Define functions for each operation (similar to your existing code)

; Rotate Left Operation
Rotate_Left:
print '     ****--Rotate Left--****'
printn
printn
print 'Enter Number: '
CALL scan_num       ; Read the input number
MOV val1, CX        ; Store in val1   

printn
MOV AX, val1
ROL AX, 1           ; Rotate AX left by 1 bit
MOV res, AX         ; Store the result in res

MOV AH,9
MOV DX, OFFSET msg_RL
INT 21h              ; Display the result message

MOV AX, res
CALL print_num       ; Print the result

JMP Con              ; Continue flow

; Rotate Right Operation
Rotate_Right:
print '     ****--Rotate Right--****'
printn
printn
print 'Enter Number: '
CALL scan_num       ; Read the input number
MOV val1, CX        ; Store in val1   

printn
MOV AX, val1
ROR AX, 1           ; Rotate AX right by 1 bit
MOV res, AX         ; Store the result in res

MOV AH,9
MOV DX, OFFSET msg_RR
INT 21h              ; Display the result message

MOV AX, res
CALL print_num       ; Print the result

JMP Con              ; Continue flow

; Rest of your code...

Con:           ; Continue Function
MOV AH,9
MOV DX, OFFSET cont    ; Display the continuation prompt
INT 21h                 ; Call interrupt
print '(Yes = 1 / No = 0) : '
CALL scan_num          ; Read the response
MOV agn, CX
printn

CMP agn, 1
JE Start               ; Jump to start if user wants to continue

CMP agn, 0
JE _Bye                ; Jump to exit

Bye:                    ; Exit function
MOV AH,9
MOV DX, OFFSET bye     ; Display exit message
INT 21h                ; Call interrupt

MAIN ENDP

DEFINE_SCAN_NUM
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS

END MAIN

HLT         ; Halting
ret         ; Return

