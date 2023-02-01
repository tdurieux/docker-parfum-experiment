FROM ghcr.io/openhd/bullseye-lite:v2.3

RUN apt update && apt install --no-install-recommends -y gnupg2 && rm -rf /var/lib/apt/lists/*;

COPY install_dep.sh /data/install_dep.sh

RUN /data/install_dep.sh

COPY . /data/

WORKDIR /data

ARG CLOUDSMITH_API_KEY=000000000000

RUN export CLOUDSMITH_API_KEY=$CLOUDSMITH_API_KEY

RUN /data/package.sh armhf raspbian bullseye docker
