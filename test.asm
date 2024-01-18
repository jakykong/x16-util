; Commander X16 boilerplate
.org $080D

.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"
   jmp start         ; absolute

CHROUT = $FFD2
NEWLINE = $0D


.include "intmath.asm"

start:
   ; Some arbitrary output for visual confirmation the test ran.
   lda #64
   jsr CHROUT
   lda #NEWLINE
   jsr CHROUT
   
   ; test division - 1 divided by 1 should = 1
   lda #$0A
   sta OPER1
   lda #$00
   sta OPER1+1
   lda #$02
   sta OPER2
   lda #$00
   sta OPER2+1
   jsr div16 
   rts



