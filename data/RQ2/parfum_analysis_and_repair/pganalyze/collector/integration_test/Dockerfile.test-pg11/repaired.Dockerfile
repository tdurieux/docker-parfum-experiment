FROM postgres:11

ARG TARGETARCH

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
