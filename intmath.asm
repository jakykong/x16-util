; Integer Math Routines (for Commander X16)
; Code by Jack Mudge <jack@mudge.dev>, but credited as needed.
; Anything that is not otherwise licensed (see in-line credits) is released
; to the public domain. No warranties, guarantees, etc.
;
; Reserve $00D4-$00DF for this code as written.
; $00D4 - Operand1 LOW
; $00D5 - Operand1 HIGH
; $00D6 - Operand2 LOW
; $00D7 - Operand2 HIGH
; $00D8 - Return1 LOW (Result)
; $00D9 - Return1 HIGH
; $00DA - Return2 LOW (Modulus, etc.)
; $00DB - Return2 HIGH
; $00DC-$00DF - Working area

OPER1 = $D4
OPER2 = $D6
RES1 = $D8
RES2 = $DA
WORK = $DC



; Unsigned 16-bit Division With Modulus
; Return1 = Operand1 / Operand2
; Return2 = Operand1 MOD Operand2 (remainder)
; Div/0 Unchecked. Code will run away.
.proc div16
   ; division steps, at most 16.
   ldx #16
   ; result begins as 0
   lda #0
   sta RES1
   sta RES1+1
loop:
   ; Update remainder
   lda OPER1
   sta RES2
   lda OPER1+1
   sta RES2+1
   ; attempt to subtract the divisor, it either fits (result bit = 1) or doesn't (result bit = 0)
   sec
   lda OPER1
   sbc OPER2
   sta OPER1
   lda OPER1+1
   sbc OPER2+1
   sta OPER1+1
   bcs fit
   bna next
fit:
   inc RES1
   ; fallthrough to .next
next:
   ; rotate RES left
   clc
   rol RES1
   rol RES1+1
   dex
   bne loop
   rts
.endproc



   


   

   



   
