FROM golang:1.12.9

RUN apt update && apt install --no-install-recommends ca-certificates libgnutls30 -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y bash git && rm -rf /var/lib/apt/lists/*;

ADD ./_bin/go.mod /src/_tmp/processor-artifacts/go.mod

RUN cd /src/_tmp/processor-artifacts/ && go mod download

ADD ./_bin/gamma-server /opt/orbs/

WORKDIR /opt/orbs

CMD ./gamma-server
