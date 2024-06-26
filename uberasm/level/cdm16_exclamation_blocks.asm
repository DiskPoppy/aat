;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Conditional Direct Map16 Switch Blocks
;	by MarioFanGamer
;
; This simple UberASM library allows to place Direct Map16 !-blocks in Lunar Magic and still
; let them affect by the switch or even invert the flags, allowing the use of inverted
; !-blocks without the of ObjecTool and custom blocks + ExAnimation (the latter which IMO is
; quite wasteful).
; Call this library from game mode 11 to allow Direct Map16 objects to be able to use it.
; Once done, simply select the DM16 objects you want to affect, go to Edit >
; Conditional Direct Map16... enter the flag number as specified below as well as whether the
; object should disappear or just use the tile of the next Map16 page and you're done.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The type of switch 
; !Regular: Flags set when corresponding switches are pressed and clear when not
; !Inverted: Flags clear when corresponding switches are pressed and set when not
; !Both: Lower four flags contain the bits for the pressed switches and upper four flags for the unpressed ones
!SwitchFlags = !Both

; The conditional direct Map16 flags to affect. Each switch reserves one flag in the order
; green (+0), yellow (+1), blue (+2) and red (+3).
; That means, if a DM16 object should check for the blue switch, you want to enter !CDM16Flag+2.
; If you set the above to !Both then add +4 to get all the inverted values.
; Note that for internal limitations, you can only enter multiples of 4 except if !SwitchFlags
; is set to !Both in which you need to use a multiple of eight instead.
!CDM16Flags = $10


; Internal defines, do not change!

!Regular = 0
!Inverted = 1
!Both = 2

!CDM16Ram #= $7FC060+(!CDM16Flags>>3)
!CDM16Upper #= !CDM16Flags&$4

if !SwitchFlags == !Both && !CDM16Flags&7 > 0
	warn "\!CDM16Flag is not divisible by 8, rounding down to nearest multiple of 8."
elseif !CDM16Flags&3 > 0
	warn "\!CDM16Flag is not divisible by 4, rounding down to nearest multiple of 4."
endif
if !SwitchFlags > 2
	error "Error, \!CDM16Flag is an invalid value!"
endif

load:
	; Disable the status bar.
	; Otherwise, there's a conflict with manual trigger 0, which displays the Demo/Iris head.
	JSL NoStatus_load

	; Lock the screen.
	STZ $1A
	STZ $1462|!addr
	LDA $95
	STA $1B
	STA $1463|!addr
	RTL

init:
    STZ $1411|!addr			;> Disable horizontal scroll.
	LDA $95					;\ Disable vertical scroll
	BNE +					;| if the screen is 00.
	STZ $1412|!addr			;/
+
	JSR check_switch_status
	RTL

main:
	STZ $00
	LDX #$03
-	LDA $1F27|!addr,x
	LSR
	ROL $00
	DEX
	BPL -
if !SwitchFlags == !Both
	LDA $00
	ASL #4
	ORA $00
	EOR #$F0
	STA !CDM16Ram
else
	if !CDM16Upper
		LDA $00
		ASL #4
		STA $00
		LDA !CDM16Ram
		AND #$0F
		ORA $00
		if !SwitchFlags == !Inverted
			EOR #$F0
		endif
	else
		LDA !CDM16Ram
		AND #$F0
		ORA $00
		if !SwitchFlags == !Inverted
			EOR #$0F
		endif
	endif
endif
	STA !CDM16Ram
	
	;JSR check_switch_status
	RTL

check_switch_status:
	; Brown block gates to the switches.
    LDA $0DC3|!addr			;\ Green Switch
	BEQ +					;| Note: Free RAM set in 057.asm.
	LDA #$01 : STA $7FC072	;|
	LDA #$01 : STA $7FC07A	;/
+
	LDA $0DC4|!addr			;\ Yellow Switch
	BEQ +					;| Note: Free RAM set in FilterYoshi_15E.asm.
	LDA #$01 : STA $7FC073	;|
	LDA #$01 : STA $7FC07B	;/
+
	LDA $0DC5|!addr			;\ Blue Switch
	BEQ +					;| Note: Free RAM set in BabaBlocks1D7.asm.
	LDA #$01 : STA $7FC074	;|
	LDA #$01 : STA $7FC07C	;/
+
	LDA $0DC6|!addr			;\ Red Switch
	BEQ +					;| Note: Free RAM set in 1BA.asm.
	LDA #$01 : STA $7FC075	;|
	LDA #$01 : STA $7FC07D	;/
+

	; Switch block indicators (pressed/unpressed)
	LDA $1F27|!addr			;\ Green Switch
	BEQ +					;|
	LDA #$01 : STA $7FC070	;|
	LDA #$01 : STA $7FC078	;/
+
	LDA $1F28|!addr			;\ Yellow Switch
	BEQ +					;|
	LDA #$01 : STA $7FC071	;|
	LDA #$01 : STA $7FC079	;/
+
	LDA $1F29|!addr			;\ Blue Switch
	BEQ +					;|
	LDA #$01 : STA $7FC076	;|
	LDA #$01 : STA $7FC07E	;/
+
	LDA $1F2A|!addr			;\ Red Switch
	BEQ +					;|
	LDA #$01 : STA $7FC077	;|
	LDA #$01 : STA $7FC07F	;/
+
	RTS
