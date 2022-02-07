docker run -it --rm --name nes-builder --privileged \
    -e DISPLAY=${DISPLAY:-:0.0} \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /home/fuumarumota/Downloads/Roms/NES:/roms \
    -v mesen_cfg:/home/mono/.config \
    -v mesen_cfg_local:/home/mono/emu/ \
    -v $(pwd)/src:/home/mono/src \
    -v $(pwd)/out:/home/mono/out \
    -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
    -v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
    -v ~/.config/pulse/cookie:/root/.config/pulse/cookie \
    nes-builder $@