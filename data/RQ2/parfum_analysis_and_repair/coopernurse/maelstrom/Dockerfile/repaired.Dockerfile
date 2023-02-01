# build stage
FROM debian:stretch-slim AS build-env
RUN apt-get update && apt install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y curl python-pip make && rm -rf /var/lib/apt/lists/*;
RUN cd /usr/local && curl -f -LO https://dl.google.com/go/go1.13.linux-amd64.tar.gz && \
    tar zxf go1.13.linux-amd64.tar.gz && rm -f go1.13.linux-amd64.tar.gz
RUN pip install --no-cache-dir --pre barrister
RUN apt install --no-install-recommends -y git libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
ENV GOROOT=/usr/local/go
ENV PATH="${GOROOT}/bin:/root/go/bin:${PATH}"
RUN go get github.com/coopernurse/barrister-go && go install github.com/coopernurse/barrister-go/idl2go
ADD . /src
RUN cd /src && make idl && make maelstromd && make maelctl

# final stage
FROM debian:stretch-slim
RUN apt-get update && apt install --no-install-recommends -y ca-certificates libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
COPY --from=build-env /src/dist/maelstromd /usr/bin
COPY --from=build-env /src/dist/maelctl /usr/bin
