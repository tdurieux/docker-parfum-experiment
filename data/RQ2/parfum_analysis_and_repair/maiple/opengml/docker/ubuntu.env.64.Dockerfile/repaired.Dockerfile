FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive
ENV ARCHITECTURE=x64

RUN apt-get update

RUN apt-get install --no-install-recommends -y \
    libassimp-dev \
    libfcl-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y \
    libglew-dev \
    libglm-dev \
    libsdl2-dev \
    libsdl2-ttf-dev \
    libsdl2-mixer-dev \
    libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y \
    gcc-8 \
    g++-8 \
    curl \
    make && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y --no-remove \
    libboost-filesystem-dev \
    libgtk-3-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install scons

RUN umask 666

RUN apt-get install --no-install-recommends -y git nano && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;