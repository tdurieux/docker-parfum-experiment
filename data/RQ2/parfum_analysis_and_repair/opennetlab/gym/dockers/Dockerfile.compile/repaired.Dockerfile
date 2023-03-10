FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y \
    sudo git python3 libglib2.0-dev build-essential \
    libgtest-dev clang nlohmann-json-dev libzmq3-dev \
    libboost-dev && rm -rf /var/lib/apt/lists/*;

# Add ONL user
ARG USER=onl
ARG UID
ARG GUID

RUN groupadd -f -r -g ${GUID} g${USER}
RUN useradd ${USER} -l -u ${UID} -g ${GUID} -m -s /bin/bash
RUN echo "${USER}:${USER}" | chpasswd
RUN adduser ${USER} sudo
USER ${USER}

# Download NS3
ARG WORK_DIR=/home/${USER}
ARG NS_DIR=${NS_ALLINONE}/${NS_VERSION}

WORKDIR ${NS_DIR}
