FROM ubuntu:18.04
RUN apt update && apt install --no-install-recommends -y \
    debhelper \
    debmake \
    dh-python \
    dh-systemd \
    dh-virtualenv \
    git \
    libsystemd-dev \
    python3-all \
    python3-pip \
    ssh && rm -rf /var/lib/apt/lists/*;
COPY build-deb.sh /
COPY rules /
COPY titus-isolate.service /
COPY titus-isolate.socket /
WORKDIR /src
CMD ["/build-deb.sh"]
