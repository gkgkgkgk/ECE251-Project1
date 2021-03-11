.data

.balign 4
scanf_msg: .asciz "Enter a string: \n"

.balign 4
scanpattern: .asciz " %[^\n]s" /* space has to be added before because a newline is left in the input buffer */

.balign 4
user_input: .skip 100

.balign 4 
err_msg: .asciz "Your string is too long\n" 

.balign 4
print_msg: .asciz "Your string is: %s\n"

.balign 4
return: .word 0

.balign 4
output: .skip 24

.text
.global main
main:
    ldr r1,addr_return
    str lr, [r1] /* stores the original return for func call */
    mov r5, #0 /* reserve register for keeping track of the flow (which string the user is inputting) */
    mov r6, #0 /* reserve register for the global char counter */
    ldr r4, addr_output
    
ask_for_string:
    add r5, #1 /* update which string user is inputting (1st or 2nd) */
    ldr r0, addr_scanf_msg
    bl printf

    ldr r0, addr_scanpattern
    ldr r1, addr_user_input
    bl scanf

    ldr r0, addr_user_input
    mov r1, #0

check_len:
    ldrb r2, [r0], #1 /* load letter from string */
    cmp r2, #0x00 /* check for null */
    beq continue_check
    str r2, [r4,r6] /* store letter into output */
    add r6, r6, #1
    add r1, r1, #1
    
    cmp r1, #13 /* if string is too long, throw an error */
    beq err
    b check_len

err:
    ldr r0, addr_err_msg
    bl printf
    mov r0, #7
    cmp r5,#1
    bne update_error /* if user gets an error on the second string, update error code to 8 */
    b final

update_error: 
    mov r0, #8
    b final

continue_check:
    cmp r5, #1
    beq ask_for_string
    b second

second: 
    ldr r0, addr_print_msg
    ldr r1, addr_output
    bl printf
    mov r0, r6

final:
    ldr r1, addr_return
    ldr lr, [r1]
    bx lr


addr_scanf_msg: .word scanf_msg
addr_scanpattern: .word scanpattern
addr_user_input: .word user_input
addr_err_msg: .word err_msg
addr_print_msg: .word print_msg
addr_return: .word return 
addr_output: .word output


/*Externals */
.global printf
.global scanf
