ARG BASE="16-bullseye"
FROM node:${BASE}

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y --no-install-recommends install software-properties-common apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y update

# base development stuff
RUN apt-get -y --no-install-recommends install \
    build-essential \
    gcc \
    libgirepository1.0-dev \
    libglib2.0-dev \
    pkg-config && rm -rf /var/lib/apt/lists/*;

# python native
RUN apt-get -y --no-install-recommends install \
    python3 \
    python3-dev \
    python3-gi \
    python3-pip \
    python3-setuptools \
    python3-wheel && rm -rf /var/lib/apt/lists/*;


# python pip
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install aiofiles debugpy typing_extensions typing

ENV SCRYPTED_DOCKER_SERVE="true"
ENV SCRYPTED_CAN_RESTART="true"
ENV SCRYPTED_VOLUME="/server/volume"
ENV SCRYPTED_INSTALL_PATH="/server"

WORKDIR /
# cache bust
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
RUN npx -y scrypted install-server
WORKDIR /server
CMD npm exec scrypted-serve
