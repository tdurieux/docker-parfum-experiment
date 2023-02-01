FROM ubuntu:22.04

RUN apt update -y && apt install --no-install-recommends -y curl unzip && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y make gcc git && rm -rf /var/lib/apt/lists/*;

ADD install-go.sh .
RUN ./install-go.sh

ADD install-protoc.sh .
RUN ./install-protoc.sh

ADD install-sass.sh .
RUN ./install-sass.sh
