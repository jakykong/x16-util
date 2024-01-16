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
   ; output a newline so we see some activity on run
   lda #NEWLINE
   jsr CHROUT
   lda #64
   jsr CHROUT
   
   ; test division - 1 divided by 1 should = 1
   lda #$01
   sta OPER1
   sta OPER2
   lda #00
   sta OPER1+1
   sta OPER2+1
   jsr div16 
   rts




