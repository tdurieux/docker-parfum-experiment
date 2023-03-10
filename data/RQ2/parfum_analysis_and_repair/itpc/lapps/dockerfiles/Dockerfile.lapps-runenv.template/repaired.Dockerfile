FROM ubuntu:URELEASE

LABEL "localhost" "Pavel Kraynyukhov" version 1.0  maintainer "pavel.kraynyukhov@gmail.com" description "LAppS run environment"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
	&& apt-get upgrade -y \
  && apt-get update \
	&& apt-get dist-upgrade -y

RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y luarocks && rm -rf /var/lib/apt/lists/*;

ENV WORKSPACE /tmp

WORKDIR ${WORKSPACE}

ADD https://github.com/ITpC/LAppS.builds/raw/master/URELEASE/lapps-XX_VERSION_XX-MTUNE-amd64.deb ${WORKSPACE}/

WORKDIR ${WORKSPACE}

RUN ls -la ${WORKSPACE}/lapps-XX_VERSION_XX-MTUNE-amd64.deb

RUN apt install --no-install-recommends -y ${WORKSPACE}/lapps-XX_VERSION_XX-MTUNE-amd64.deb && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -f -y

WORKDIR /opt/lapps/run

RUN echo "LAppS-XX_VERSION_XX is installed under /opt/lapps prefix. To run LAppS use /opt/lapps/bin/lapps.MTUNE [-d] from within /opt/lapps/run directory. -d is an optional argument do run LAppS as a deamon."

RUN echo "Optionally /opt/lapps/bin/lapps.MTUNE.notls and /opt/lapps/bin/lapps.MTUNE.nostats.notls builds are provided for convinience"

RUN echo "You may add/install lua modules you want to use with LAppS from luarocks repository. You may twick this Dockerfile or do these operations within running container."
