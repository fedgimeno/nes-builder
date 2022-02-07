#!/bin/bash

if [ $# -eq 0 ]
then
    echo "Please provide a project's name. ie './make.sh my_project'"
    exit 1
fi

CHR_IN_F=./src/$1.png
PRG_IN_F=./src/$1.s
PRG_OUT_F=./out/$1_prg.bin
CHR_OUT_F=./out/$1_chr.bin
NES_OUT_F=./out/$1.nes

echo $PRG_OUT_F

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

python3 ./tools/nes-chr-encode/nes_chr_encode.py --color0=000000 --color1=333333 --color2=555555 --color3=AAAAAA $CHR_IN_F $CHR_OUT_F || { echo .; echo "Error assembling CHR"; exit 1; }

#Make NES rom
echo "Making NES rom..."
if test -f "$NES_OUT_F"; then
    echo "$NES_OUT_F already exists, deleting it..."
fi
cat $PRG_OUT_F $CHR_OUT_F > $NES_OUT_F || { echo .; echo "Error compiling NES file"; exit 1; }

echo "Running NES rom..."
chmod 777 ./emu/Mesen.exe
mono ./emu/Mesen.exe $NES_OUT_F || exit 1
