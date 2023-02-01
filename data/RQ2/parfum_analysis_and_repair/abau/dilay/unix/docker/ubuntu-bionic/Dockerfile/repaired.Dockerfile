FROM ubuntu:bionic

RUN apt-get update && apt-get install --no-install-recommends -y build-essential git qt5-default qt5-qmake libglm-dev && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh /usr/bin/

ENTRYPOINT entrypoint.sh
