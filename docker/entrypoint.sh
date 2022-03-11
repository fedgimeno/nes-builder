#!/bin/bash
mkdir -p ./in
cp -R ./src/* ./in
CHR_IN_F=./in/$1.png
PRG_IN_F=./in/$1.s
PRG_OUT_F=./out/$1_prg.bin
CHR_OUT_F=./out/$1_chr.bin
NES_OUT_F=./out/$1.nes

#Patch source to fix nested director includes
echo "Patching sources..."
python3 patch_source.py

if [ ! "$?" -eq 0 ]; then
    echo "Error patching sources..."
    exit $?
fi

#Compile program
if test -f "$PRG_OUT_F"; then
    echo "$PRG_OUT_F already exists, deleting it..."
    rm $PRG_OUT_F
fi

echo "Assembling program..."
./asm6f $PRG_IN_F $PRG_OUT_F || { echo .; echo "Error assembling PRG"; exit 1; }

#Compiling CHR
echo "Compiling CHR"
if test -f "$CHR_OUT_F"; then
    echo "$CHR_OUT_F already exists, deleting it..."
    rm $CHR_OUT_F
fi

python3 ./tools/nes-chr-encode/nes_chr_encode.py --color0=$COLOR_0 --color1=$COLOR_1 --color2=$COLOR_2 --color3=$COLOR_3 $CHR_IN_F $CHR_OUT_F || { echo .; echo "Error assembling CHR"; exit 1; }

#Make NES rom
echo "Making NES rom..."
if test -f "$NES_OUT_F"; then
    echo "$NES_OUT_F already exists, deleting it..."
fi

cat $PRG_OUT_F $CHR_OUT_F > $NES_OUT_F || { echo .; echo "Error compiling NES file"; exit 1; }
wine $HOME/emu/fceux.exe $NES_OUT_F || exit 1

