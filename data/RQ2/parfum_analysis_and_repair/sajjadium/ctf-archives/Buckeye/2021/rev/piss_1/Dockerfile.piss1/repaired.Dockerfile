FROM ubuntu:20.04 as builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && apt-get install --no-install-recommends -y \
autoconf \
bison \
flex \
gcc \
g++ \
git \
libprotobuf-dev \
libnl-route-3-dev \
libtool \
make \
pkg-config \
protobuf-compiler \
uidmap \
cmake \
python3 && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/google/nsjail --branch 3.0 && \
cd nsjail && \
make -j8 && \
mv nsjail /bin && \
cd / && \
rm -rf nsjail

RUN git clone https://github.com/aquynh/capstone.git --branch 4.0.2 && \
cd capstone && \
./make.sh && \
cd ..

RUN git clone https://github.com/keystone-engine/keystone.git && \
cd keystone && \
git checkout 1475885daa7e566c064ae9754706e1a0ba24be3b && \
mkdir build && \
cd build && \
../make-share.sh && \
cd ..


FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
 apt-get install --no-install-recommends -y libprotobuf17 libnl-route-3-200 && \
rm -rf /var/lib/apt/lists/*

RUN useradd -m ctf && \
mkdir /chroot/ && \
chown root:ctf /chroot && \
chmod 770 /chroot

COPY --from=builder /bin/nsjail /bin
COPY --from=builder /capstone/libcapstone.so.4 /usr/lib/
COPY --from=builder /keystone/build/llvm/lib/libkeystone.so.0 /usr/lib

WORKDIR /home/ctf/

COPY flag1.txt ./flag.txt
COPY jail.cfg run.sh /

COPY bins/piss1 /home/ctf/challenge

RUN chown -R root:ctf . && \
chmod 440 flag.txt

CMD /run.sh
