# nes-builder
A quick and dirty, dockerized environment for NES development that runs on linux.

You will need the following dependencies pre-installed:


* docker

## Setup

Clone this repository in your local machine and open a terminal on the repository's folder, then follow the instructions below.

### Build the docker image
```
docker build  ./docker/. -t nes-builder
```
Building the image will take a while so you can go grab a beer/coffee, walk the dog, talk to your mom...

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
