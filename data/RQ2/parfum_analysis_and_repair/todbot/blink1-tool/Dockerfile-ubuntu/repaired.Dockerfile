FROM ubuntu
MAINTAINER Rob Powell <rob.p.tec@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
        build-essential \
        pkg-config \
        libudev-dev && rm -rf /var/lib/apt/lists/*;


RUN mkdir /home/blinkdev

ENV HOME /home/blinkdev

COPY . ${HOME}/commandline

WORKDIR ${HOME}/commandline

RUN make

ENV PATH ${HOME}/commandline:${PATH}

CMD ["blink1-tool", "-t 1000", "--random=100"]