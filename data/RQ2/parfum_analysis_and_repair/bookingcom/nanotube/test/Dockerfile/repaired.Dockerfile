FROM golang:1.18

RUN mkdir /nanotube
WORKDIR /nanotube

COPY . .

RUN apt-get -y update && apt-get -y --no-install-recommends install bzip2 bc && rm -rf /var/lib/apt/lists/*;

RUN make nanotube
RUN make test/sender/sender
RUN make test/receiver/receiver

CMD make local-end-to-end-test
