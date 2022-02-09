FROM mono

ARG DEBIAN_FRONTEND=noninteractive
ENV HOME /home/mono

RUN apt-get update && apt-get install -y x11-apps
RUN apt install -y libsdl2-2.0-0 gnome-themes-standard libgtk2.0-0
RUN apt install -y libasound2-dev pulseaudio
RUN useradd mono

#Get Python3, pip, and the PyPng python module
RUN apt install -y python3 python3-pip
RUN pip3 install pypng

#Install Git
RUN apt install -y git

#Get the Mesen emulator
RUN apt-get install unzip -y && \
    curl -k -L https://github.com/SourMesen/Mesen/releases/download/0.9.9/Mesen.0.9.9.zip -o mesen.zip && \
    unzip mesen.zip -d ${HOME}/emu && \
    rm mesen.zip

#Get nes-chr-encode tool
RUN git clone https://github.com/play3577/nes-chr-encode.git ${HOME}/tools/nes-chr-encode

#Get and build the asm6f assembler
RUN git clone https://github.com/freem/asm6f.git ./asm6f_src && \
    gcc asm6f_src/asm6f.c -o $HOME/asm6f && \
    rm -rf asm6f_src

RUN mkdir -p ${HOME}/Desktop && \
    mkdir -p ${HOME}/.config/mesen && mkdir -p ${HOME}/out && \
    chown -R mono ${HOME}/

COPY entrypoint.sh $HOME/entrypoint.sh
USER mono
WORKDIR $HOME
ENTRYPOINT ["./entrypoint.sh"]