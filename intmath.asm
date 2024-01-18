; Integer Math Routines (for Commander X16)
; Code by Jack Mudge <jack@mudge.dev>, but credited as needed.
; Anything that is not otherwise licensed (see in-line credits) is released
; to the public domain. No warranties, guarantees, etc.

OPER1 = $44
OPER2 = $46
RES1 = $48
ERROR = $4A

; Convenience symbols for division
DIVIDEND = OPER1
DIVISOR = OPER2
QUOTIENT = RES1

; Unsigned 16-bit Division With Remainder
; Inputs:  OPER1 = Dividend
;          OPER2 = Divisor
; Outputs: OPER1 = Quotient (result)
;          RES1  = Remainder
;          ERROR = 1 if div/0, 0 otherwise.
.proc div16
   ; Check if DIVISOR == 0
   lda DIVISOR
   bne :+
   lda DIVISOR+1
   bne :+
   jmp divzero
   : ; not divzero

   ; result starts at 0
   lda #0
   sta QUOTIENT
   sta QUOTIENT+1

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

loop:
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
   bne loop

done:
   ; DIVIDEND has accumulated the remainder
   ; QUOTIENT should already contain the divided result.
   lda #0
   sta ERROR ; no errors
   rts


divzero:
   ; handle division by zero by flagging error
   lda #$01
   sta ERROR ; error occurred
   rts
.endproc



