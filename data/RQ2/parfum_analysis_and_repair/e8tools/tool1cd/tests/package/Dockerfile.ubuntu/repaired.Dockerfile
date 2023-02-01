FROM ubuntu:xenial

RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:dmpas/e8
RUN apt-get update

RUN apt-get install -y --no-install-recommends ctool1cd && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT /usr/bin/ctool1cd
