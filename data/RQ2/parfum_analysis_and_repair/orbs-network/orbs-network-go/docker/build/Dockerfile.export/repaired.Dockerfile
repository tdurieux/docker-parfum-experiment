FROM golang:1.12.9

RUN apt update && apt install --no-install-recommends ca-certificates libgnutls30 -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y git daemontools && rm -rf /var/lib/apt/lists/*;

ADD ./_bin/go.mod /src/_tmp/processor-artifacts/go.mod

RUN cd /src/_tmp/processor-artifacts/ && go mod download

ADD ./_bin/orbs-node /opt/orbs/

ADD ./_bin/healthcheck /opt/orbs/

ADD ./entrypoint.sh /opt/orbs/service

VOLUME /usr/local/var/orbs/

VOLUME /opt/orbs/logs

VOLUME /opt/orbs/status

WORKDIR /opt/orbs

HEALTHCHECK CMD /opt/orbs/healthcheck --url http://localhost:8080/status --output /opt/orbs/status/status.json --log /opt/orbs/logs/healthcheck

CMD ./orbs-node
