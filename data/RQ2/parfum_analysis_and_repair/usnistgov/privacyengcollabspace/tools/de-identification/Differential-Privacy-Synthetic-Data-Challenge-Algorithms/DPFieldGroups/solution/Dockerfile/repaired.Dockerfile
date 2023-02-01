FROM ubuntu:16.04

## Install General Requirements
RUN apt-get update && \
    apt-get install --no-install-recommends -y openjdk-8-jdk && \
    apt-get install -y --no-install-recommends \
    apt-utils \
    build-essential \
    cmake \
    git \
    wget \
    nano \
    software-properties-common && rm -rf /var/lib/apt/lists/*;

WORKDIR /x

# copy entire directory where docker file is into docker container at /work
COPY . /x/

RUN chmod 777 run.sh
RUN chmod 777 compile.sh
RUN sh compile.sh

ENTRYPOINT [ "/x/run.sh" ]
