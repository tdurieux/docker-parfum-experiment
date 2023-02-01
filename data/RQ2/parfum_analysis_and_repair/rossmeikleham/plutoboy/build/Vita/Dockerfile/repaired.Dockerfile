from gnuton/vitasdk-docker:latest

ENV VITASDK /usr/local/vitasdk

RUN apt-get update -y && apt install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;

# Install SDL2 and other VitaSDK libraries
RUN git clone https://github.com/vitasdk/vdpm;\ 
    cd vdpm;\ 
    ./install-all.sh;\
    ./vitasdk-update;

RUN mkdir /plutoboy_vita
ADD . /plutoboy_vita/
WORKDIR /plutoboy_vita/build/Vita

RUN mkdir build

# Build and copy the VPK back to the host
CMD cd build; cmake ..; make; cp Plutoboy.vpk /mnt;
