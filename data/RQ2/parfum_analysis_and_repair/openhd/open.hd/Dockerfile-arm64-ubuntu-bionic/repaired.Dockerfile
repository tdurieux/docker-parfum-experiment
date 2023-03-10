FROM openhd/tegra_linux_sample-root-filesystem_r32.4.2_aarch64:v2

RUN apt update

COPY install_dep.sh /data/install_dep.sh

RUN /data/install_dep.sh

COPY . /data/

WORKDIR /data

ARG CLOUDSMITH_API_KEY=000000000000

RUN export CLOUDSMITH_API_KEY=$CLOUDSMITH_API_KEY

RUN /data/package.sh arm64 ubuntu bionic docker