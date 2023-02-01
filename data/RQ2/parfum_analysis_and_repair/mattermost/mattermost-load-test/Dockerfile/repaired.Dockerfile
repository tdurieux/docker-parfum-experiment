FROM golang:latest

ENV PATH="/mattermost-load-test/bin:${PATH}"
ENV PATH="/mattermost/bin:${PATH}"
ARG LOADTEST_BINARY
ARG MM_BINARY

WORKDIR /

RUN apt-get update \
    && apt-get -y --no-install-recommends install \
      curl \
      jq \
      netcat \
      net-tools \
      iproute2 \
      dnsutils \
      graphviz && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /mattermost/data \
    && curl -f $MM_BINARY | tar -xvz \
    && rm -rf /mattermost/config/config.json

RUN mkdir -p /mattermost-load-test \
	&& curl -f $LOADTEST_BINARY | tar -xvz \
	&& rm -f /mattermost-load-test/loadtestconfig.json

WORKDIR /mattermost-load-test
CMD ["tail", "-f", "/dev/null"]
