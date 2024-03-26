load:
	JSL MinStatus_load
	RTL

init:
	JSL DisableSideExit_init
	LDA $0DBE|!addr
	CLC
	ADC #$01
	STA $0DBE|!addr
	RTL

main:
	; Disable select button.
	LDA #%00100000 : STA $00
	LDA #%00000000 : STA $01
	JSL DisableButton_main
	RTL