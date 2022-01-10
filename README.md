# nes-builder
A quick and dirty environment for NES development that runs on linux.

You will need the following dependencies pre-installed:


* Python3 with pip

## Setup

* Install the mono runtimes:

```
$ sudo apt update
$ sudo apt install dirmngr gnupg apt-transport-https ca-certificates
$ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
$ sudo sh -c 'echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" > /etc/apt/sources.list.d/mono-official-stable.list'
$ sudo apt update
$ sudo apt install mono-complete

```

* Install the PyPng python module

`$ sudo pip3 install pypng`

* Install the the 'asm6f' 6502 / NES assembler

Get the source code from the author's repository
`$ git clone https://github.com/freem/asm6f.git`

Run the provided setup.sh / setup.bat in order to install all the dependencies. You should run the script with administrative privileges.

## Usage


### Windows
Use `make.bat [project_name]`

### Linux
`./make.sh [project_name]`

The script expects the following input files in the `./src` directory
* [project_name].s, *.s ---> The main 6502 ASM file plus any other ASM source files that may be included from the main module.
* [project_name].png ---> The Sprites and BG tiles as a 128 x 256 PNG file.

The script will generate the following binary files in the `./bin` directory:
* [project_name].nes
* [project_name]_prg.bin
* [project_name]_chr.bin

After successfully assemblying the project, the Mesen emulator will be launched using the newly generated .nes file.
