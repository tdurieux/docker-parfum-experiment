FROM bazelment/lrte:latest

RUN apt-get update && apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

ADD . /trunk
WORKDIR /trunk

RUN git submodule update --init
