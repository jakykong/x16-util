; I/O routines targeting the Commander X16
;

; Dependencies (be sure they're included somewhere):
; .include "intmath.asm"

; Print a 16-bit unsigned number as base 10
; Inputs: A - low byte
;         Y - high byte
; Outputs: Side effect - decimal digits printed to terminal
;          No zero padding - use pru1610z 
; 

CHROUT = $FFD2


; PRint Unsigned 16 bit in Base 10
.proc pru1610
   ldx #0
   
stack:
   ; Divide and update
   sta DIVIDEND
   sty DIVIDEND+1
   lda #10
   sta DIVISOR
   lda #0
   sta DIVISOR+1
   jsr div16

   ; Next digit is remainder
   lda DIVIDEND
   pha
   inx ; # digits pushed to stack

   ; quotient carries forward
   lda QUOTIENT
   ldy QUOTIENT+1

   ; No more digits?
   ; checked late so initial 0 will still print a digit (0)
   cmp #0
   bne stack
   cpy #0
   bne stack
   bra print

print:
   ; Pop all of the stacked digits and output
   pla
   clc
   adc #$30
   jsr CHROUT

   dex
   bne print

   rts

.endproc


