FROM debian:bullseye AS bullseye

RUN echo "deb http://deb.debian.org/debian bullseye-backports main " >> /etc/apt/sources.list

RUN apt update
RUN apt install --no-install-recommends -y apt-utils apt-transport-https ca-certificates debian-archive-keyring && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y wget curl tree git gcc build-essential libelf-dev; rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y linux-kbuild*; rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y linux-headers*amd64 && rm -rf /var/lib/apt/lists/*;
RUN apt -t bullseye-backports --no-install-recommends install -y linux-headers*amd64 && rm -rf /var/lib/apt/lists/*;
RUN apt clean all

ADD . /elkeid
WORKDIR /elkeid/driver
RUN bash ./batch_compile.sh