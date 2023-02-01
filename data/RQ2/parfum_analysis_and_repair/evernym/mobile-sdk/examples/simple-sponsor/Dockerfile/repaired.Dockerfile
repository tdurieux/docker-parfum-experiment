FROM ubuntu:bionic
ENV DEBIAN_FRONTEND="noninteractive" TZ="Europe/Moscow"
ARG module
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
    gnupg \
    pbuilder \
    ubuntu-dev-tools \
    apt-file \
    software-properties-common \
    ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN update-ca-certificates -f -v

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE7709D068DB5E88 &&\
    add-apt-repository "deb https://repo.sovrin.org/sdk/deb bionic stable"

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
    python3 \
    python3-pip \
    libsodium-dev \
    libtool \
    pkg-config \
    build-essential \
    autoconf \
    automake \
    uuid-dev \
    wget \
    libindy && rm -rf /var/lib/apt/lists/*;

COPY . /app
WORKDIR /app
RUN sh zeromq-setup.sh

RUN pip3 install --no-cache-dir -r requirements.txt
EXPOSE 4321
CMD [ "python3", "server.py" ]
