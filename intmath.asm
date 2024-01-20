; Integer Math Routines (for Commander X16)
; Code by Jack Mudge <jack@mudge.dev>, but credited as needed.
; Anything that is not otherwise licensed (see in-line credits) is released
; to the public domain. No warranties, guarantees, etc.

; Reserved memory for integer math library
OPER1 = $D4
OPER2 = $D6
RES1 = $D8
ERROR = $DA ; 1byte

; Convenience symbols for division
DIVIDEND = OPER1
DIVISOR = OPER2
QUOTIENT = RES1

; Convenience symbols for multiplication
MULTIPLICAND = OPER1
MULTIPLIER = OPER2
PRODUCT = RES1

; Unsigned 16-bit Division With Remainder
; Inputs:  OPER1 = Dividend
;          OPER2 = Divisor
; Outputs: OPER1 = Quotient (result)
;          RES1  = Remainder
;          ERROR = 1 if div/0, 0 otherwise.
;          Registers: A, X, Y unchanged
; .ifref div16 ; Why doesn't this work?
div16:
   ; save register state
   pha
   phx
   phy

   ; Check if DIVISOR == 0
   lda DIVISOR
   bne :+
   lda DIVISOR+1
   bne :+
   jmp @divzero
   : ; not divzero

   ; result starts at 0
   stz QUOTIENT
   stz QUOTIENT+1

   ; Always start with at least one trial subtraction
   ldx #1

   ; Rotate DIVISOR until high bit = 1 so subtractions are positioned correctly
   : ; start rotate loop
   lda DIVISOR+1
   bmi :+
   asl DIVISOR
   rol DIVISOR+1
   inx ; number of shifts here corresponds to number of subtraction steps
   bra :-
   : ; end rotate loop

@loop:
   ; Make next lowest bit of result available for setting in next iteration
   ; on first iteration will rotate #$0000
   asl QUOTIENT
   rol QUOTIENT+1

   ; try subtraction
   sec
   lda DIVIDEND
   sbc DIVISOR
   tay
   lda DIVIDEND+1
   sbc DIVISOR+1

   ; result bit = 1 and new remainder if subtraction succeeds
   bcc :+
   inc QUOTIENT
   sty DIVIDEND
   sta DIVIDEND+1
   :

   ; shift DIVISOR into next position
   lsr DIVISOR+1
   ror DIVISOR

   dex
   bne @loop

@done:
   ; DIVIDEND has accumulated the remainder
   ; QUOTIENT should already contain the divided result.
   stz ERROR ; no errors
   ply
   plx
   pla
   rts


@divzero:
   ; handle division by zero by flagging error
   lda #$01
   sta ERROR ; error occurred
   ply
   plx
   pla
   rts
;.endif ; .ifref div16


; Unsigned 16-bit multiplication
; Inputs: OPER1 = MULTIPLICAND
;         OPER2 = MULTIPLIER
; Outputs: RES1 = PRODUCT (OPER1 * OPER2)
;          ERROR = 1 if integer overflow, 0 otherwise
; .ifref mulu16 ; Why doesn't this work?
mulu16:
    ldx #16
    stz PRODUCT
    stz PRODUCT+1

@loop:
    asl PRODUCT
    rol PRODUCT+1

    asl MULTIPLIER
    rol MULTIPLIER+1
    bcc @skipadd
    
    clc
    lda PRODUCT
    adc MULTIPLICAND
    sta PRODUCT
    lda PRODUCT+1
    adc MULTIPLICAND+1
    sta PRODUCT+1
    bcs @overflow

@skipadd:
    dex
    bne @loop

    stz ERROR
    rts

@overflow: 
    lda #1
    sta ERROR
    rts
; .endif .ifref mulu16


