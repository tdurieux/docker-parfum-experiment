from devkitpro/devkitarm:20210510

RUN apt-get update && apt-get install --no-install-recommends -y gcc g++ zip && rm -rf /var/lib/apt/lists/*;

# Install makerom
RUN cd / && git clone https://github.com/profi200/Project_CTR
RUN cd /Project_CTR/makerom && git checkout 8a9f9bda55d71274799eacf && make
ENV PATH="/Project_CTR/makerom/:${PATH}"

# Install bannertool
RUN git config --global url."https://github.com/".insteadOf git://github.com/
RUN cd / && git clone https://github.com/Steveice10/bannertool
RUN cd /bannertool && git submodule update --init --recursive && make
ENV PATH="/bannertool/output/linux-x86_64/:${PATH}"

RUN mkdir /plutoboy_3DS
ADD . /plutoboy_3DS/
WORKDIR /plutoboy_3DS/build/3DS

CMD make clean && make && \
    bannertool makebanner -i banner.png -a jingle.wav -o banner.bnr &&\
    makerom -rsf Plutoboy.rsf -elf Plutoboy.elf -icon Plutoboy.smdh -banner banner.bnr -f cia -o Plutoboy.cia; cp Plutoboy.3dsx Plutoboy.cia /mnt;
