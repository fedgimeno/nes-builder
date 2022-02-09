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

docker run -it --rm --name nes-builder --privileged \
    -e DISPLAY=${DISPLAY:-:0.0} \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v mesen_cfg:/home/mono/.config \
    -v mesen_cfg_local:/home/mono/emu/ \
    -v $(pwd)/$1/src:/home/mono/src \
    -v $(pwd)/$1/out:/home/mono/out \
    -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
    -v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
    -v ~/.config/pulse/cookie:/root/.config/pulse/cookie \
    nes-builder $2
    