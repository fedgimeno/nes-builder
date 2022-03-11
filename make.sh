#!/bin/bash
if [ $# -lt 2 ]
then
    echo "Please provide a project's folder and name. ie './make.sh projects/demo demo'"
    exit 1
fi

if [ ! -d "./$1/out" ]
then
    mkdir -p "./$1/out"
fi

docker run -it --rm --ipc host --name nes-builder-fceux \
    -e DISPLAY=:0 \
    -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $(pwd)/$1/src:/home/wine/src \
    -v $(pwd)/$1/out:/home/wine/out \
    -v fceux_cfg:/home/wine/emu:rw \
    -v ~/Downloads/Roms/NES:/home/wine/roms \
    -v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
    -v ~/.config/pulse/cookie:/root/.config/pulse/cookie \
    --device /dev/dri:/dev/dri \
    nes-builder $2