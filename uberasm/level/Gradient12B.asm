;=======================================
; Mode 2 + Mode 0 COLDATA Gradient
; Channels: Red, Green, Blue
; Table Size: 54
; No. of Writes: 224
; 
; Generated by GradientTool
;=======================================

; Set up the HDMA gradient.
; Uses HDMA channels 3 and 4.
init:
	REP   #$20 ; 16-bit A

	; Set transfer modes.
	LDA   #$3202
	STA   $4330 ; Channel 3
	LDA   #$3200
	STA   $4340 ; Channel 4

	; Point to HDMA tables.
	LDA   #Gradient1_RedGreenTable
	STA   $4332
	LDA   #Gradient1_BlueTable
	STA   $4342

	SEP   #$20 ; 8-bit A

	; Store program bank to $43x4.
	PHK
	PLA
	STA   $4334 ; Channel 3
	STA   $4344 ; Channel 4

	; Enable channels 3 and 4.
	LDA.b #%00011000
	TSB   $6D9F

load:
    lda #$01
    sta $13E6|!addr

	RTL ; <-- Can also be RTL.

; --- HDMA Tables below this line ---
Gradient1_RedGreenTable:
db $4C,$21,$44
db $02,$22,$44
db $02,$23,$44
db $02,$24,$44
db $01,$25,$44
db $02,$26,$44
db $01,$27,$44
db $03,$28,$44
db $02,$29,$44
db $01,$2A,$44
db $02,$2B,$44
db $02,$2C,$44
db $02,$2D,$44
db $01,$2E,$44
db $02,$2F,$44
db $7B,$30,$44
db $00

Gradient1_BlueTable:
db $80,$88
db $60,$88
db $00