.INESPRG $01
.INESCHR $01
.INESMAP $00
.INESMIR $01

.ORG $C000

INCLUDE system.s

main:
;******************************************************************************
; Initialize System Variables              								      *
;******************************************************************************
	LDA #$02
	STA OAM_DMA_PG		;Set the OAM memory page to $200


;******************************************************************************
; Main program                          								      *
;******************************************************************************
	
	;Initialize palettes
	lda #<PaletteData			;Get low byte of the PaletteData address
	sta $10
	lda #>PaletteData			;Get high byte of the PaletteData address
	sta $11
	jsr load_whole_palette

	;Load attributes
	lda #$04					;Set length of data to write
	sta RES_MEM_TMP
	lda #$C0					;Set ppu address lo byte
	sta RES_MEM_TMP + 1
	lda #$23					;Set ppu address high byte
	sta RES_MEM_TMP + 2
	lda #<AttributeData			;Set low byte of the PaletteData address
	sta RES_MEM_TMP + 3
	lda #>AttributeData			;Set high byte of the PaletteData address
	sta RES_MEM_TMP +4
	lda #$00
	sta RES_MEM_TMP + 5			;Set Pointer offset = 0
	jsr load_atributes

	;Write nametable
	lda #$0C					;Set length of data to write
	sta RES_MEM_TMP
	lda #$21					;Set ppu address lo byte
	sta RES_MEM_TMP + 1
	lda #$20					;Set ppu address hi byte
	sta RES_MEM_TMP + 2
	lda #<NtData				;Set low byte of the PaletteData address
	sta RES_MEM_TMP + 3
	lda #>NtData				;Set high byte of the PaletteData address
	sta RES_MEM_TMP + 4
	jsr write_nametable

	;Enable sprites, background , no clipping
	lda #$1E
	sta PPU_MASK
	
	;Enable NMI, sprites pt 1, bg pt 0
	lda #$88
	sta PPU_CTRL


forever:					;Eternal loop	
	jmp forever


;******************************************************************************
; Interrupts	                         								      *
;******************************************************************************
	
nmi:
	;Backup regs
	pha
	txa
	pha
	tya
	pha	
		
	;OAM DMA
	lda #$00
	sta PPU_OAM_ADDR
	lda OAM_DMA_PG
	sta PPU_OAM_DMA
	
	;No scrolling
	lda PPU_STATUS
	lda #$00
	sta PPU_SCROLL	
	sta PPU_SCROLL	
	
	;Restore regs
	pla
	tay
	pla
	tax
	pla

	;Return
	rti

irq:
	rti

PaletteData:	
	.DB $1D,$19,$27,$2A,$1D,$00,$00,$00,$1D,$00,$00,$00,$1D,$00,$00,$00  ;background palette data	
	.DB $1D,$00,$00,$00,$1D,$00,$00,$00,$1D,$00,$00,$00,$1D,$00,$00,$00  ;background palette data	
AttributeData:
	.DB $00, $00, $00
NtData:
	.DB $41, $3E, $45, $45, $48, $00, $50, $48, $4B, $45, $3D, $5C


.ORG $FF00

;***********************************************************************************
; Initialization Routine        										           *
;***********************************************************************************

reset:
	sei					;Ignore IRQs
	cld					;clear decimal mode
	ldx #$40
    stx APU_FRAME_CTR 	; disable APU frame IRQ
    ldx #$ff
    txs   		     	; Set up stack
    inx        			; now X = 0
    stx PPU_CTRL		; disable NMI
    stx PPU_MASK	 	; disable rendering
    stx APU_DMC_IRQ		; disable DMC IRQs
	bit PPU_STATUS		;clear VBLANK flag
	jsr vblank_wait		;wait for 1st vblank
	jsr clear_memory
	jsr vblank_wait		;wait for 2nd vblank
	jmp main

;***********************************************************************************
; Interrupt vectors														     	   *
;***********************************************************************************
	
.ORG $FFFA
	.DW nmi
	.DW reset
	.DW irq
