FROM wine-docker:latest

#Create user so we don't run wine as root
RUN useradd -u 1000 -d /home/wine -m -s /bin/bash wine
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/wine && mkdir -p /etc/sudoers.d \
    echo "wine:x:${uid}:${gid}:wine,,,:/home/wine:/bin/bash" >> /etc/passwd && \
    echo "wine:x:${uid}:" >> /etc/group && \
    echo "wine ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wine && \
    chmod 0440 /etc/sudoers.d/wine && \
    chown ${uid}:${gid} -R /home/wine

#Install python dependencies and git
RUN apt-get update -y && apt install -y git python3 python3-pip && pip3 install pypng

USER wine
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