# Docker file used to create an environment with which to build a release

FROM ubuntu:bionic

# Install Dependencies
# Upgrade any ubuntu packages
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
    build-essential \
    cmake \
    python3 \
    python3-pip \
    git && \
    pip3 install --no-cache-dir invoke && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 1 && \
    update-alternatives --set python /usr/bin/python3 && rm -rf /var/lib/apt/lists/*;

# Add a user
ARG USER=bento4
ARG UID=1000
ARG GID=1000
RUN useradd -m ${USER} --uid=${UID}

# Run as the user we have setup
USER ${UID}:${GID}
WORKDIR /home/${USER}

CMD ["bash"]
