
incsrc "vwf_defines.asm"

print "INIT ",pc
    PHX
    PHK
    PLA
    STA.l !VWF_DATA+$02
    STA.l !VWF_ASM_PTRS+$02
    REP #$30
    LDA !E4,x
    AND #$00F0
    LSR #3
    STA $00
    LDA !D8,x
    AND #$00F0
    ASL 
    ORA $00
    TAX
    LDA.l DataPtr,x
    STA.l !VWF_DATA
    LDA.w #RoutinePtr
    STA.l !VWF_ASM_PTRS
    SEP #$30
    PLX

print "MAIN ",pc
    RTL


BinPtr:
	incbin "vwf_data2.bin"
DataPtr:
	dw BinPtr+$0,  BinPtr+$5C2,  BinPtr+$1424,  BinPtr+$15BE,  BinPtr+$1871,  BinPtr+$1CEB,  BinPtr+$209D,  BinPtr+$223B
	dw BinPtr+$2F11,  BinPtr+$3D42
RoutinePtr:
