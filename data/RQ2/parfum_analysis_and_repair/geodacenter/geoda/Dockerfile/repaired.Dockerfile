FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install --no-install-recommends -y git build-essential && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp/geoda

COPY . .

RUN mkdir -p /tmp/geoda/o
RUN chmod +x /tmp/geoda/BuildTools/ubuntu/install.sh
CMD OS="focal" VER="1.18.2" APT="sudo apt-get" WORK_DIR="/tmp/geoda/geoda/BuildTools/ubuntu" /tmp/geoda/geoda/BuildTools/ubuntu/install.sh