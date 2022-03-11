FROM wine-docker:latest

#Install python dependencies and git
RUN sudo apt-get update -y && sudo apt install -y git python3 python3-pip && sudo pip3 install pypng

ENV HOME /home/wine

WORKDIR $HOME

#Get and build the asm6f assembler
RUN git clone https://github.com/freem/asm6f.git ./asm6f_src && \
    gcc asm6f_src/asm6f.c -o ./asm6f && \
    rm -rf asm6f_src

#Install FCEUX emulator
RUN wget --no-check-certificate https://sourceforge.net/projects/fceultra/files/Binaries/2.6.3/fceux-2.6.3-win32.zip/download -O fceux.zip
RUN mkdir -p "$HOME/emu" && unzip fceux.zip -d "$HOME/emu"

#Get nes-chr-encode tool
RUN git clone https://github.com/play3577/nes-chr-encode.git ./tools/nes-chr-encode
ENV COLOR_0 000000
ENV COLOR_1 555555
ENV COLOR_2 AAAAAA
ENV COLOR_3 FFFFFF

#Setup the x86 wine prefix env vars
ENV WINEARCH win32 
ENV WINEPREFIX /home/wine/wine32

COPY entrypoint.sh ./entrypoint.sh
COPY patch_source.py $HOME/patch_source.py
ENTRYPOINT ["./entrypoint.sh"]