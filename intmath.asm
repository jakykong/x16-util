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

OPER1 = $44
OPER2 = $46
RES1 = $48
RES2 = $4A
ERROR = $4C
WORK = $4D



; Unsigned 16-bit Division With Modulus
; Return1 = Operand1 / Operand2
; Return2 = Operand1 MOD Operand2 (remainder)
.proc div16
   ; Check if OPER2 == 0
   lda OPER2
   bne :+
   lda OPER2+1
   bne :+
   jmp divzero
   : ; not divzero
   
   ; at most 16 steps of the division
   ldx #16
   ; result starts at 0
   lda #0
   sta RES1
   sta RES1+1

   ; OPER2 needs to be positioned for long division,
   ; i.e., high bit needs to be the most significant 1.
   lda OPER2
   bmi loop
   ; else fall through to shiftdivisor
shiftdivisor:
   ; shift OPER2 until MSB is set
   ; Guaranteed by zero check at start of proc.
   asl OPER2
   rol OPER2+1
   bmi loop
   bra shiftdivisor
loop:
   ; at each stage of loop, try to subtract.
   ; if subtract borrows, zero instances fit:
   ;     treat current value as remainder & dividend
   ;     next digit in result is 0
   ; if subtract doesn't borrow, one instance fit:
   ;     treat subtracted value as remainder & dividend
   ;     next digit in result is 1
   ; shift divisor right for next digit & continue loop

   ; subtract OPER1 - OPER2 -> WORK
   sec
   lda OPER1
   sbc OPER2
   sta WORK
   lda OPER1+1
   sbc OPER2+1
   sta WORK+1
   
   bcs subnoborrow
   ; fall through to subborrow
subborrow:
   ; subtraction carried: 
   ; next digit of result is 0
   asl RES1
   rol RES1+1
   ; keep current OPER1
   bra next

subnoborrow:
   ; subtraction didn't carry
   ; next digit of result is 1
   asl RES1
   rol RES1+1
   inc RES1
   ; use subtraction result as next dividend
   lda WORK
   sta OPER1
   lda WORK+1
   sta OPER1+1
   ; fall through to next

next:
   ; rotate OPER2 right for next subtraction
   lsr OPER2+1
   ror OPER2
   ; loop until all bits calculated
   dex
   bne loop
   ; fall through to done

done:
   ; remainder in OPER1
   lda OPER1
   sta RES2
   lda OPER1+1
   sta RES2+1
   ; clear any error flags
   lda #$00
   sta ERROR
   rts

divzero:
   ; handle division by zero by flagging error
   lda #$01
   sta ERROR
   rts
.endproc



