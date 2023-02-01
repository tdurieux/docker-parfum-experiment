FROM golang:1.17

RUN apt-get -y update && apt-get install --no-install-recommends -y build-essential mingw-w64 openjdk-11-jre-headless git && rm -rf /var/lib/apt/lists/*;

RUN mkdir /mcdex
ADD . /mcdex
WORKDIR /mcdex
RUN git checkout -f
