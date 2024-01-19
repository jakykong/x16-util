; Commander X16 boilerplate
.org $080D

.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"
   jmp start         ; absolute

; CHROUT = $FFD2 ; also defined in io.asm for now
NEWLINE = $0D


.include "util.asm"

start:
   ; test printing some numbers

   ; print 65535
   lda #$FF
   ldy #$FF
   jsr pru1610
   lda #NEWLINE
   jsr CHROUT

   ; print 0
   lda #$00
   ldy #$00
   jsr pru1610
   lda #NEWLINE
   jsr CHROUT

   ; print 9876
   lda #$94
   ldy #$26
   jsr pru1610
   lda #NEWLINE
   jsr CHROUT
   
   rts 

