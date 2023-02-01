FROM ubuntu

ENV GOSU_VERSION 1.10

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y dist-upgrade && \
    apt-get install -y curl gnupg && \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
    curl -L -o /gosu "https://github.com/tianon/gosu/releases/download/1.10/gosu-${dpkgArch}" && \
    curl -L -o /gosu.asc "https://github.com/tianon/gosu/releases/download/1.10/gosu-${dpkgArch}.asc" && \
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
    gpg --batch --verify /gosu.asc /gosu && \
    rm -r /gosu.asc && \
    chmod +x /gosu && \
    /gosu nobody true

# Copy the binary over from the builder image
COPY kubekite /
RUN chmod +x /kubekite

COPY job-templates/job.yaml /

CMD ["/kubekite"]
