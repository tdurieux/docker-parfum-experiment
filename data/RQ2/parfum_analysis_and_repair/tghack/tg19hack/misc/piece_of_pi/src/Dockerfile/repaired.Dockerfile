FROM ubuntu:bionic

RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
RUN apt update && apt-get build-dep -y qemu-system-arm && apt install --no-install-recommends -y vim git && rm -rf /var/lib/apt/lists/*;
COPY ./vm /opt/
WORKDIR /opt/
RUN apt install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT [ "./build.sh" ]
