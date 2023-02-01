FROM golang:1.18.2-buster

RUN apt-get update && apt-get -y --no-install-recommends install libunbound-dev && apt-get -y clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /letsdebug

CMD make deps letsdebug-server
