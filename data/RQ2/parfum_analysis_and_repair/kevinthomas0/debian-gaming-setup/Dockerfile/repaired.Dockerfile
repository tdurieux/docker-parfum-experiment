FROM debian

LABEL maintainer="me@kevinthomas.dev"

RUN echo "deb http://deb.debian.org/debian buster-backports main contrib non-free" >>/etc/apt/sources.list

RUN apt-get update && apt-get -y --no-install-recommends -t buster-backports install shellcheck && rm -rf /var/lib/apt/lists/*;

COPY . /debian-gaming-setup

WORKDIR /debian-gaming-setup

RUN shellcheck debian-gaming-setup

RUN ./test/debian-gaming-setup.bats
