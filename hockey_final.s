#By Alexander Domina & John Daly
#Paddle needs to be in the space one clock cycle before the ball for a hit to register.
#Ball resets after every goal, paddles reset after every game
#Game ends when ether the player or the computer scores 15 goals
#Use the buttons on the bottom to control the game, they are labeled with their functions.
start:
addiu r8, r0, 15 #r8 = 15, define r8 as the x value for the ball's location
addiu r9, r0, 7  #r9 = 7, define r9 as the y value for the ball's location
addiu r14, r0, 0 #define the user score to 0
addiu r15, r0, 0 #define the computer score to 0
addiu r12, r0, 7 #define r12 = 7 as starting location of outer computer paddle, y axis
addiu r13, r0, 7 #define r13 = 7 as starting location of inner computer paddle, y axis
addiu r10, r0, 7 #define r10 = 7 as starting location of outer player paddle, y axis
addiu r11, r0, 7 #define r11 = 7 as starting location of inner player paddle, y axis 
addiu r4, r0, 31 #define r4 = 31, the max value in the x direction
addiu r5, r0, 15 #define r5 = 15, the max value in the y direction
addiu r6, r0, 4 #defines x value of players goalee, and one of the possible button presses 0100
addiu r7, r0, 10 #defines x value of players paddle
addiu r2, r0, 27 #defines x value of computers goalee
addiu r3, r0, 21 #defines x value of computers paddle
addu r16, r0, r0 #tag for computer goalee movement
addiu r17, r0, 1 #tag for computer paddle movement
addiu r18, r0, 0 #tag for y axis movement (ball)
addiu r19, r0, 0 #tag for x axis movement (ball)
addiu r20, r0, 1 #holds 1 value for tag checking and button presses 0001
addiu r21, r0, 0x8000 #location in memory for graphics
sll r21, r21, 16
addiu r21, r21, 0x0008
addu r22, r0, r0 #holding value for graphics
addiu r23, r0, 0x8000 #location in memory for buttons
sll r23, r23, 16
addiu r23, r23, 0x0010
addu r24, r0, r0 #holding value for controls
addiu r25, r0, 2 #holds 2 value for button presses 0010
addiu r26, r0, 8 #holds 8 value for button presses 1000

graphics:
#ball
lw r22, 0(r0) #load old ball
addiu r22, r22, 6 #reset previous pixel
sw r22, 0(r21) #cover up old ball location
addu r22, r0, r0 #reset r22  
addu r22, r8, r0 #add ball's x value to graphics
sll r22, r22, 4 #shift 4 to write to add y value
addu r22, r9, r22 #add ball's y value to graphics
sll r22, r22, 3 #shift 3 to write to color value
addiu r22, r22, 0x0 #set color to black
sw r22, 0(r21) #display ball location
sw r22, 0(r0) #store ball location

#player goalee
lw r22, 4(r0) #load old player goalee
addiu r22, r22, 6 #reset previous pixel
sw r22, 0(r21) #cover up old player goalee
addu r22, r0, r0 #reset r22  
addu r22, r6, r0 #add player goalee's x value to graphics
sll r22, r22, 4 #shift 4 to write to add y value
addu r22, r10, r22 #add player goalee's y value to graphics
sll r22, r22, 3 #shift 3 to write to color value
addiu r22, r22, 0x0 #set color to black
sw r22, 0(r21) #display player's goalee 
sw r22, 4(r0) #store player's goalee 

#player paddle
lw r22, 8(r0) #load old player paddle
addiu r22, r22, 6 #reset previous pixel
sw r22, 0(r21) #cover up old player paddle
addu r22, r0, r0 #reset r22  
addu r22, r7, r0 #add player paddle's x value to graphics
sll r22, r22, 4 #shift 4 to write to add y value
addu r22, r11, r22 #add player paddle's y value to graphics
sll r22, r22, 3 #shift 3 to write to color value
addiu r22, r22, 0x0 #set color to black
sw r22, 0(r21) #display players's paddle
sw r22, 8(r0) #store player's paddle

#computer goalee
lw r22, 12(r0) #load old computer goalee
addiu r22, r22, 6 #reset previous pixel
sw r22, 0(r21) #cover up old computer goalee
addu r22, r0, r0 #reset r22  
addu r22, r2, r0 #add computer goalee's x value to graphics
sll r22, r22, 4 #shift 4 to write to add y value
addu r22, r12, r22 #add computer goalee's y value to graphics
sll r22, r22, 3 #shift 3 to write to color value
addiu r22, r22, 0x0 #set color to black
sw r22, 0(r21) #display computer goalee
sw r22, 12(r0) #store computer goalee

#computer paddle
lw r22, 16(r0) #load old computer paddle
addiu r22, r22, 6 #reset previous pixel
sw r22, 0(r21) #cover up old computer paddle
addu r22, r0, r0 #reset r22  
addu r22, r3, r0 #add computer paddle's x value to graphics
sll r22, r22, 4 #shift 4 to write to add y value
addu r22, r13, r22 #add computer paddle's y value to graphics
sll r22, r22, 3 #shift 3 to write to color value
addiu r22, r22, 0x0 #set color to black
sw r22, 0(r21) #display computer paddle
sw r22, 16(r0) #store computer paddle

ball:
beq r8, r0, computer_score
beq r8, r4, user_score
beq r9, r5, decrease_y
beq r9, r0, increase_y
beq r18, r0, decrease_y
beq r18, r20, increase_y
decrease_y:
addiu r9, r9, -1
addiu r18, r0, 0 #set tag to 0
j ball_x #go to part of code to check the balls x coordinate
increase_y:
addiu r9, r9, 1
addu r18, r0, r20 #set tag to 1
ball_x:
beq r8, r0, increase_x
beq r8, r4, decrease_x
beq r19, r0, decrease_x
beq r19, r20, increase_x
decrease_x:
addiu r19, r0, -1
addiu r8, r8, -1
j paddle_detect
increase_x:
addu r19, r0, r20
addiu r8, r8, 1

paddle_detect:
beq r8, r6, check_pgy #if the balls x value equals the players goalee's x value, check if y's are equal
beq r8, r7, check_ppy #if the balls x value equals the players paddle's x value, check if y's are equal
beq r8, r2, check_cgy #if the balls x value equals the computers goalee's x value, check if y's are equal
beq r8, r3, check_cpy #if the balls x value equals the computers paddle's x value, check if y's are equal
check_cgy:
bne r9, r12, paddlec #if the balls and the paddles y values are not equal go to paddlec, else change the balls x direction
addiu r8, r8, -1
addu r19, r0, r0
j paddlec
check_cpy:
bne r9, r13, paddlec #if the balls and the paddles y values are not equal go to paddlec, else change the balls x direction
addiu r8, r8, -1
addu r19, r0, r0
j paddlec
check_pgy:
bne r9, r10, paddlec #if the balls and the paddles y values are not equal go to paddlec, else change the balls x direction
addiu r8, r8, 1
addu r19, r0, r20
j paddlec
check_ppy:
bne r9, r11, paddlec #if the balls and the paddles y values are not equal go to paddlec, else change the balls x direction
addiu r8, r8, 1
addu r19, r0, r20

paddlec: 
beq r12, r0, paddlec1
beq r12, r5, paddlec2
beq r17, r20, paddlec1
beq r17, r0, paddlec2 
paddlec1:
addiu r12, r12, 1 #add 1 to r12
addu r17, r0, r20
j goaleec #go to goaleec
paddlec2: 
addiu r12, r12, -1 #add -1 to r12
addu r17, r0, r0

goaleec:
beq r13, r0, goaleec1
beq r13, r5, goaleec2
beq r16, r20, goaleec1
beq r16, r0, goaleec2 
goaleec1: 
addiu r13, r13, 1 #add 1 to r13
addu r16, r0, r20
j player #go to player
goaleec2: 
addiu r13, r13, -1 #add -1 to r13
addu r16, r0, r0

player:
lw r24, 0(r23) #load which button is being press into r24
beq r24, r20, paddlep1 #paddle moves up
beq r24, r25, paddlep2 #paddle moves down
beq r24, r6, paddlep3
beq r24, r26, paddlep4
j graphics #if no user input, go back to graphics

paddlep1:
ble r11, r0, graphics #if the y value of the paddle is less than or equal to 0 go back and don't move the paddle
addiu r11, r11, -1 #decrease paddle y value by 1
j graphics #go back to graphics 

paddlep2:
bge r11, r5, graphics #if the y value of the paddle is greater than or equal to the max y value go back and don't move paddle
addiu r11, r11, 1 #increase paddle y value by 1
j graphics #go back to graphics

paddlep3:
ble r10, r0, graphics #if the y value of the goalee is less than or equal to 0 go back and don't move the paddle
addiu r10, r10, -1 #decrease goalee y value by 1
j graphics #go back to graphics

paddlep4:
bge r10, r5, graphics #if the y value of the goalee is greater than or equal to the maxy vale go back and don't move the paddle
addiu r10, r10, 1 #increase goalee y value by 1
j graphics #go back to graphics




computer_score:
addiu r15, r15, 1 #increment computer score by 1
#addiu r12, r0, 7 #outer computer paddle starting y
#addiu r13, r0, 7 #inner computer paddle starting y
#addiu r10, r0, 7 #outer computer paddle starting x
#addiu r11, r0, 7 #inner computer paddle starting x
addiu r8, r0, 15  #bring ball back to starting x
addiu r9, r0, 7  #bring ball back to starting y
beq r15, r5, restart #if computer score = 15 go to restart function
j graphics #return to graphics

user_score:
addiu r14, r14, 1 #increment user score by 1
#addiu r12, r0, 7 #outer computer paddle starting y
#addiu r13, r0, 7 #inner computer paddle starting y
#addiu r10, r0, 7 #outer computer paddle starting x
#addiu r11, r0, 7 #inner computer paddle starting x
addiu r8, r0, 15  #bring ball back to starting x
addiu r9, r0, 7  #bring ball back to starting y
beq r14, r5, restart #if user score = 15 go to restart function
j graphics #return to graphics

restart:
j start #go to where the checks start