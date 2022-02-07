;*******************************
;*** System Reserved Memory  ***
;*******************************

RES_MEM_PG        = $F0         ;Reserve $F0 to $FF (16 bytes) in the RAM's zero page 
RES_MEM_TMP       = $E0          ;Reserve $E0 to $E7 (8 bytes) of disposable memory 

;*******************************
;*** System Variables        ***
;*******************************

BUTTONS_1  = RES_MEM_PG         ;F0
BUTTONS_2  = RES_MEM_PG + 1     ;F1
OAM_DMA_PG = RES_MEM_PG + 2     ;F2

;*******************************
;**** NES Registers         ****
;*******************************

;PPU
PPU_CTRL     = $2000
PPU_MASK     = $2001
PPU_STATUS   = $2002
PPU_OAM_ADDR = $2003
PPU_OAM_DATA = $2004
PPU_SCROLL   = $2005
PPU_ADDRESS  = $2006
PPU_DATA     = $2007
PPU_OAM_DMA  = $4014

;CONTROLLERS
JOYPAD_1 = $4016
JOYPAD_2 = $4017

;APU
APU_DMC_IRQ   = $4010
APU_STATUS    = $4015
APU_FRAME_CTR = $4017


;*******************************
;**** Wait for vblank       ****
;*******************************
vblank_wait:
	bit PPU_STATUS
	bpl vblank_wait
	rts

	
;*******************************
;**** Clear ram memory      ****
;*******************************
clear_memory:
	pha
	txa
	pha	
	ldx #$00
	lda #$ff
	-					
    sta $000,x    
    sta $200,x
    sta $300,x
    sta $400,x
    sta $500,x
    sta $600,x
    sta $700,x
    inx
    bne -	
	pla
	tax
	pla
	rts

;*********************
;**** Read Joypad ****
;*********************
; At the same time that we strobe bit 0, we initialize the ring counter
; so we're hitting two birds with one stone here
readjoy:
	pha
	txa
	pha
	tya
	pha	
    lda #$01
    ; While the strobe bit is set, buttons will be continuously reloaded.
    ; This means that reading from JOYPAD_1 will only return the state of the
    ; first button: button A.
    sta JOYPAD_1
    sta BUTTONS_1
    lsr a        ; now A is 0
    ; By storing 0 into JOYPAD1, the strobe bit is cleared and the reloading stops.
    ; This allows all 8 buttons (newly reloaded) to be read from JOYPAD1.
    sta JOYPAD_1
	-
    lda JOYPAD_1
    lsr a	       ; bit 0 -> Carry
    rol BUTTONS_1   ; Carry -> bit 0; bit 7 -> Carry
    bcc -
	;Restore registers
    pla
	tay
	pla
	tax
	pla
    rts
	

;**********************************
;**** Load data in nametable   ****
;**********************************
; @ Parameters (actually popped in reverse order)
	; RES_MEM_TMP - Length of the data to write
	; RES_MEM_TMP + 1 - Attr. table start address lo
	; RES_MEM_TMP + 2 - Attr. table start address hi	
	; RES_MEM_TMP + 3 - Pointer to source data (takes 2 bytes)
	
write_nametable:
	pha
	txa
	pha
	tya
	pha
	
	;Set up PPU address for writing nt
	lda RES_MEM_TMP + 2
	sta PPU_ADDRESS
	lda RES_MEM_TMP + 1
	sta PPU_ADDRESS
	ldy #$00
	-
		lda (RES_MEM_TMP + 3), y
		sta PPU_DATA
		iny
		cpy RES_MEM_TMP
		bne -
	
	pla
	tay
	pla
	tax
	pla
	rts


;**********************************
;**** Load data in palettes    ****
;**********************************
;$10: lo, $11: hi
load_whole_palette:
	pha
	txa
	pha
	tya
	pha

	ldy #$00				;LoadPalettes, start at 0
	lda PPU_STATUS			;Reset vram latch
	lda #$3F
	sta PPU_ADDRESS
	lda #$00
	sta PPU_ADDRESS
-:
	lda ($10), y      		; load data from address (PaletteData + the value in y)
	sta PPU_DATA			; write to PPU
	iny                     ; X = X + 1
	cpy #$20                ; Compare X to hex $20, decimal 32
	bne -		    		; Branch to pal_loop if compare was Not Equal to zero
                          	; if compare was equal to 32, keep going down		
	pla
	tay
	pla
	tax
	pla
	rts	


;**********************************
;***  Load data in attr. table  ***
;**********************************
; @ Parameters (actually popped in reverse order)
	; RES_MEM_TMP - Length of the data to write
	; RES_MEM_TMP + 1 - Attr. table start address lo
	; RES_MEM_TMP + 2 - Attr. table start address hi	
	; RES_MEM_TMP + 3 - Pointer to source data (takes 2 bytes)
	; RES_MEM_TMP + 5 - Pointer offset

load_atributes:
	pha
	txa
	pha
	tya
	pha
	
	lda PPU_STATUS				;Reset vram latch
	lda RES_MEM_TMP + 2
	sta PPU_ADDRESS
	lda RES_MEM_TMP + 1
	sta PPU_ADDRESS
	ldy RES_MEM_TMP + 5			;Start at pointer offset

-:
	lda (RES_MEM_TMP + 3), y
	sta PPU_DATA
	iny
	cpy RES_MEM_TMP				;Compare to length of the data to write
	bne -

	pla
	tay
	pla
	tax
	pla
	rts	

