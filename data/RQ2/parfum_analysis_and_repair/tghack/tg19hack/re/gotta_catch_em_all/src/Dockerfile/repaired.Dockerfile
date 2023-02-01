FROM ubuntu:bionic

RUN apt update && apt install --no-install-recommends -y \
    make \
    git \
    gcc \
    byacc \
    flex \
    pkg-config \
    libpng-dev && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/rednex/rgbds /opt/rgbds

WORKDIR /opt/rgbds
RUN make install
RUN git clone https://github.com/pret/pokered.git /opt/pokered

WORKDIR /opt/pokered
RUN make red

ENTRYPOINT [ "/bin/bash" ]
