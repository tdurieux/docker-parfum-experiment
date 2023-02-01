FROM ubuntu:16.04

ARG uid=1000
ARG indy_stream=stable

ENV LC_ALL="C.UTF-8"
ENV LANG="C.UTF-8"
ENV SHELL="/bin/bash"

# Install environment
RUN apt-get update -y && apt-get install --no-install-recommends -y \
    git \
    wget \
    python3.5 \
    python3-pip \
    python-setuptools \
    python3-nacl \
    apt-transport-https \
    ca-certificates \
    build-essential \
    pkg-config \
    cmake \
    libssl-dev \
    libsqlite3-dev \
    libsodium-dev \
    curl && rm -rf /var/lib/apt/lists/*;

# Add indy user
RUN useradd -ms /bin/bash -u $uid indy

# Install LibIndy
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 68DB5E88
RUN echo "deb https://repo.sovrin.org/sdk/deb xenial $indy_stream" >> /etc/apt/sources.list

# Fix LibIndy version to 1.5.0
RUN echo "Package: libindy" >> /etc/apt/preferences
RUN echo "Pin: version 1.6.1" >> /etc/apt/preferences
RUN echo "Pin-Priority: 1000" >> /etc/apt/preferences

RUN apt-get update && apt-get install --no-install-recommends -y libindy && rm -rf /var/lib/apt/lists/*;

USER root

# Install nodejs
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install --no-install-recommends -y \
        nodejs \
        build-essential && rm -rf /var/lib/apt/lists/*;

ENV HOME=~
WORKDIR $HOME

RUN mkdir nodejs
WORKDIR nodejs

ENV LD_LIBRARY_PATH=$HOME/.local/lib:/usr/local/lib:/usr/lib

# Copy rest of the app
COPY . .

# RUN npm install --save indy-sdk
RUN npm install && npm cache clean --force;

CMD [ "npm", "start" ]

EXPOSE 8000
