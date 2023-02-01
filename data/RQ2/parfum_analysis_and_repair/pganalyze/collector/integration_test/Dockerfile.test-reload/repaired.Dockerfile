FROM ubuntu:18.04

ARG TARGETARCH

# Systemd-based container setup
ENV container=docker
RUN apt-get update -qq && apt-get install --no-install-recommends -y -q systemd && rm -rf /var/lib/apt/lists/*;
COPY integration_test/container.target /etc/systemd/system/container.target
RUN ln -sf /etc/systemd/system/container.target /etc/systemd/system/default.target
STOPSIGNAL SIGRTMIN+3
ENTRYPOINT ["/sbin/init"]
CMD ["--log-level=info"]

ENV GOVERSION 1.17
ENV CODE_DIR /collector
ENV PATH $PATH:/usr/local/go/bin

# Packages required for both building and packaging
RUN apt-get update -qq && apt-get install --no-install-recommends -y -q build-essential git curl && rm -rf /var/lib/apt/lists/*;

# Golang
RUN curl -f -o go.tar.gz -sSL "https://golang.org/dl/go${GOVERSION}.linux-${TARGETARCH}.tar.gz"
RUN tar -C /usr/local -xzf go.tar.gz && rm go.tar.gz

# Build the collector
COPY . $CODE_DIR
WORKDIR $CODE_DIR
RUN make build_dist

# Make sure collector state can be saved
RUN mkdir /var/lib/pganalyze-collector/

RUN cp $CODE_DIR/pganalyze-collector /usr/bin/
RUN cp $CODE_DIR/pganalyze-collector-helper /usr/bin/
RUN cp $CODE_DIR/pganalyze-collector-setup /usr/bin/
RUN cp $CODE_DIR/contrib/pganalyze-collector.conf /etc/pganalyze-collector.conf

RUN sh $CODE_DIR/packages/src/deb-systemd/after-install.sh
