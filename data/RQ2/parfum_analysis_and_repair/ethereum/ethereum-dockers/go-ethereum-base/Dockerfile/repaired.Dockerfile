FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install --no-install-recommends -qy git mercurial software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -qy libgmp3-dev libreadline6-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -qy build-essential && rm -rf /var/lib/apt/lists/*;

# golang
RUN apt-get install --no-install-recommends -qy golang && rm -rf /var/lib/apt/lists/*;
