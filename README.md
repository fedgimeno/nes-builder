# nes-builder
A quick and dirty environment for NES development that runs on linux.

You will need the following dependencies pre-installed:


* Python3 with pip

## Setup

Clone this repository in your local machine and open a terminal on the repository's folder, then follow the instructions below.

### Install the mono runtimes:

```
sudo apt update
sudo apt install dirmngr gnupg apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
sudo sh -c 'echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" > /etc/apt/sources.list.d/mono-official-stable.list'
sudo apt update
sudo apt install mono-complete

```

### Install the PyPng python module

`sudo pip3 install pypng`

### Install the the 'asm6f' 6502 / NES assembler

Get the source code from the author's repository

`git clone https://github.com/freem/asm6f.git ./asm6f_src`

Compile the C source code

```
gcc asm6f_src/asm6f.c -o asm6f
rm -rf asm6f_src
```

### Install the 'nes-chr-encode' tool
`git clone https://github.com/play3577/nes-chr-encode.git ./tools/nes-chr-encode` 

### Download the 'Mesen' NES emulator
```
sudo apt-get install unzip -y
curl -L https://github.com/SourMesen/Mesen/releases/download/0.9.9/Mesen.0.9.9.zip -o mesen.zip
unzip mesen.zip -d emu
rm mesen.zip
```

## Usage

`./make.sh [project_name]`

The 'make.sh' script expects the following input files in the `./src` directory
* [project_name].s, *.s ---> The main 6502 ASM file plus any other ASM source files that may be included from the main module.
* [project_name].png ---> The Sprites and BG tiles as a 128 x 256 PNG file. For more information on how the png file needs to be formatted, please check the 'nes-chr-encode' documentation at the author's github: https://github.com/play3577/nes-chr-encode.

The script will generate the following output binary files in the `./bin` directory:
* [project_name].nes
* [project_name]_prg.bin
* [project_name]_chr.bin

After successfully assemblying the project, the Mesen emulator will be launched using the newly generated .nes file.
