; Commander X16 boilerplate
.org $080D

.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"
   jmp start         ; absolute

NEWLINE = $0D

.include "util.asm"

start:
   ; Some arbitrary output just so the template does something
   lda #64
   jsr CHROUT
   lda #NEWLINE
   jsr CHROUT
   
