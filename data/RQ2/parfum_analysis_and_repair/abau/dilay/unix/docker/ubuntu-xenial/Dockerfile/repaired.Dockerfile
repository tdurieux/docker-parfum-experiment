FROM ubuntu:xenial

RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository -y ppa:beineri/opt-qt592-xenial
RUN apt-get update

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential git qt59base libglm-dev libgl1-mesa-dev && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh /usr/bin/

ENTRYPOINT entrypoint.sh
