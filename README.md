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
Building the image will take a while so you can go grab a beer/coffee, walk the dog, call your mom...

## Usage

`./make.sh [project_folder] [project_name]`


* `[project_folder]`---> This is the NES project's working directory, where the src directory exists .i.e `projects/demo` .
* `[project_name]`---> This is the NES project's name. The main source's filename must match this name. For example, for a 
project called `demo` that is in the `projects/demo` directory, the main source file must exist at `projects/demo/src/demo.s`.

The 'make.sh' script expects the following input files in the `[project_folder]/src` directory
* `[project_name]`.s, *.s ---> The main 6502 ASM file plus any other ASM source files that may be included from the main module.
* `[project_name]`.png ---> The Sprites and BG tiles as a 128 x 256 PNG file. For more information on how the png file needs to be formatted, please check the 'nes-chr-encode' documentation at the author's github: https://github.com/play3577/nes-chr-encode.


The script will generate the following output binary files in the `[project_folder]/out` directory:
* `[project_name]`.nes     - The actual assembled NES rom (PRG + CHR).
* `[project_name]`_prg.bin - The PRG rom
* `[project_name]`_chr.bin - The CHR rom

After successfully assemblying the project, the [Mesen](https://www.mesen.ca/) emulator will be launched using the newly generated .nes file.

To see the builder in action right away, you can try to build the demo project I have included in the `projects/demo` folder:
`./make.sh "projects/demo" demo`

Optionally, you can create a link to a directory that its in your $PATH, so that you can conveniently use the "make.sh" script anywhere, i.e.
`ln make.sh ~/.local/bin/nes-builder`, and use it like `nes-builder "projects/demo" demo` for example.
