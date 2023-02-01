FROM ubuntu:20.04

# Install nsjail

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
&& \
rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/google/nsjail --branch 3.0 && \
cd nsjail && \
make -j8 && \
mv nsjail /bin && \
cd / && \
rm -rf nsjail

# Challenge config starts here

FROM ubuntu:20.04

COPY --from=0 /usr/bin/nsjail /usr/bin/

RUN apt-get update && \
 apt-get install --no-install-recommends -y libprotobuf17 libnl-route-3-200 && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pwntools && pip install --no-cache-dir qiling
RUN rm -rf /var/lib/apt/lists/*

RUN useradd -m ctf && \
mkdir /chroot/ && \
chown root:ctf /chroot && \
chmod 770 /chroot

WORKDIR /home/ctf/app

COPY . ./
RUN mv jail.cfg run.sh / && \
chown -R root:ctf . && \
chmod 440 flag.txt

WORKDIR /app/

ENV TERM=xterm-256color
CMD /run.sh
