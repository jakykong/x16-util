.ifndef __io__
__io__ = 1
; I/O routines targeting the Commander X16
;
; Dependencies (be sure they're included somewhere):
; .include "cbm_kernal.asm" ; from ca65\asminc (CHROUT)
; .include "intmath.asm"



; address register
io_addr_reg: .byte $00,$00


; PRint Zero-terminated STRing
; Inputs: A - low byte of starting address
;         Y - high byte of starting address
; Outputs: Side effect - string printed to terminal
.proc przstr
   sta io_addr_reg
   sty io_addr_reg+1
   ldx #0

loop:
   lda io_addr_reg,x
   cmp #0
   beq end
   jsr CHROUT
   inx
   bne loop

end:
   rts
.endproc ; .proc przstr

   


; PRint Unsigned 16 bit as Base 10
; Inputs: A - low byte
;         Y - high byte
; Outputs: Side effect - decimal digits printed to terminal
;          No zero padding - use pru1610z 
; 
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

.endproc ; .proc pru1610


.endif ; .ifndef __io__
