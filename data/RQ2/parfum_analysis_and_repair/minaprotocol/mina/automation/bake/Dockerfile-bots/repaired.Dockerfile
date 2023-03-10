FROM codaprotocol/coda-bots:0.0.13-beta-1

RUN mkdir /healthcheck/ && curl -f https://raw.githubusercontent.com/MinaProtocol/mina/develop/dockerfiles/scripts/healthcheck-utilities.sh -o /healthcheck/utilities.sh

RUN echo '"genesis_state_timestamp": "2020-12-16T12:00:00Z"' > /root/daemon.json

RUN apt-get -y update && apt-get -y --no-install-recommends install jq && rm -rf /var/lib/apt/lists/*;
