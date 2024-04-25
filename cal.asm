INCLUDE EMU8086.INC     ; Including Library

org 100h

.data       ; Data Segment

msg_intro db '1. Addition', 0dh,0ah, '2. Subtraction', 0dh,0ah, '3. Multiplication', 0dh,0ah, '4. Division', 0dh,0ah, '5. Negation', 0dh,0ah, '6. Square', 0dh,0ah, '7. Cube', 0dh,0ah, '8. Bitwise OR', 0dh,0ah, '9. Bitwise AND', 0dh,0ah, '10. Bitwise XOR', 0dh,0ah, '11. Bitwise NOT', 0dh,0ah, '12. Modulo', 0dh,0ah, '13. Rotate Left', 0dh,0ah, '14. Rotate Right', 0dh,0ah, '0. Exit', '$'

msg_A db 'Result of Addition = $', 0dh,0ah
msg_S db 'Result of Subtraction = $', 0dh,0ah
msg_M db 'Result of Multiplication = $', 0dh,0ah
msg_D db 'Result of Division = $', 0dh,0ah
msg_N db 'Negative of Number = $', 0dh,0ah
msg_SQ db 'Square of the Number = $', 0dh,0ah
msg_CB db 'Cube of the Number = $', 0dh,0ah
msg_OR db 'Result of Bitwise OR = $', 0dh,0ah
msg_AND db 'Result of Bitwise AND = $', 0dh,0ah
msg_XOR db 'Result of Bitwise XOR = $', 0dh,0ah
msg_NOT db 'Result of Bitwise NOT = $', 0dh,0ah
msg_MD db 'Remainder of Division = $', 0dh,0ah
msg_RL db 'Rotate Left Result = $', 0dh,0ah
msg_RR db 'Rotate Right Result = $', 0dh,0ah

cont db 'Would you like to continue? (1 = Yes, 0 = No): $'
bye db 'Thank you for using the calculator! See you next time! $'

val1 dw ?       ; Uninitialized
val2 dw ?       ; Uninitialized  
res dw ?
agn dw ?

.code       ; Code Segment
MAIN PROC
    
MOV AX, @data
MOV DS, AX

Start:                  ; Start Label

print '**** Simple Calculator ****'
printn     ; New Line

print 'Choose an option:'
printn
MOV AH, 9
MOV DX, OFFSET msg_intro
INT 21h              ; Display the list of operations

printn
print 'Your choice: '
CALL scan_num           ; Read the user's option
printn

CMP CX, 0
JE _Bye                 ; If user chooses 0, jump to exit

CMP CX, 1
JE Addition             ; Jump to Addition function

CMP CX, 2
JE Subtraction          ; Jump to Subtraction function

CMP CX, 3
JE Multiplication       ; Jump to Multiplication function

CMP CX, 4
JE Division             ; Jump to Division function

CMP CX, 5
JE Negation             ; Jump to Negation function

CMP CX, 6
JE Square               ; Jump to Square function

CMP CX, 7
JE Cube                 ; Jump to Cube function

CMP CX, 8
JE _OR                  ; Jump to OR function

CMP CX, 9
JE _AND                 ; Jump to AND function

CMP CX, 10
JE _XOR                 ; Jump to XOR function

CMP CX, 11
JE _NOT                 ; Jump to NOT function

CMP CX, 12
JE Modulus              ; Jump to Modulo function

CMP CX, 13
JE Rotate_Left          ; Jump to Rotate Left function

CMP CX, 14
JE Rotate_Right         ; Jump to Rotate Right function

; Addition Function
Addition:
print 'Addition:'
printn
print 'Enter first number: '
CALL scan_num       ; Read the first number
MOV val1, CX        ; Store it in val1   

print 'Enter second number: '
CALL scan_num       ; Read the second number
MOV val2, CX        ; Store it in val2

MOV AX, val1
ADD AX, val2
MOV res, AX

MOV AH, 9
MOV DX, OFFSET msg_A
INT 21h              ; Display the result message

MOV AX, res
CALL print_num       ; Print the result

JMP Con               ; Go to the continuation function

; Subtraction Function
Subtraction:
print 'Subtraction:'
printn
print 'Enter first number: '
CALL scan_num       ; Read the first number
MOV val1, CX        ; Store it in val1   

print 'Enter second number: '
CALL scan_num       ; Read the second number
MOV val2, CX        ; Store it in val2

MOV AX, val1
SUB AX, val2        ; Subtraction operation
MOV res, AX         ; Store result in `res`

MOV AH, 9
MOV DX, OFFSET msg_S
INT 21h              ; Display the result message

MOV AX, res
CALL print_num       ; Print the result

JMP Con               ; Go to the continuation function

; Continue Function
Con:
printn
MOV AH, 9
MOV DX, OFFSET cont    ; Display continuation message
INT 21h
CALL scan_num          ; Read user's response
MOV agn, CX
printn

CMP agn, 1
JE Start               ; If user wants to continue, go back to Start

CMP agn, 0
JE _Bye                ; If user wants to exit, go to the exit function

_Bye:                   ; Exit function
MOV AH, 9
MOV DX, OFFSET bye    ; Display the exit message
INT 21h                ; Call interrupt to display the exit message

MAIN ENDP

DEFINE_SCAN_NUM
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS

END MAIN

HLT         ; Halting
ret         ; Return
