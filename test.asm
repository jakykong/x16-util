; Commander X16 boilerplate
.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
   jmp start         ; absolute
   data: .byte $01,$23,$45,$67,$89,$AB,$CD,$EF
.segment "CODE"

.include "intmath.asm"

start:
   ; test division - check result in monitor for now
   lda #00
   sta OPER1
   sta OPER2
   lda #4
   sta OPER1+1
   lda #2
   sta OPER2+1
   jsr div16 ; expect result #02
   brk




