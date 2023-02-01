FROM ubuntu:16.04
LABEL maintainer='Charlton Rodda'

# Need to specify UID and GID so they match the external user.
# UNAME has no significance.
ARG UNAME=builder
ARG UID=1000
ARG GID=1000
ARG ostype=Linux

RUN apt-get -qq update && apt-get -qq -y --no-install-recommends install curl build-essential gcc-arm-linux-gnueabihf vim && rm -rf /var/lib/apt/lists/*;

RUN bash -c 'if [ ${ostype} == Linux ]; then groupadd -r --gid ${GID} ${UNAME} || true; fi'
RUN useradd -u $UID -g $GID -m $UNAME
USER $UNAME

RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly -y
ENV PATH="${PATH}:/home/$UNAME/.cargo/bin"

RUN rustup target add armv7-unknown-linux-gnueabihf

# make the registry folder to ensure correct permissions
RUN mkdir -p "/home/$UNAME/.cargo/registry"

ADD ./.cargo/config /home/$UNAME/.cargo/config
