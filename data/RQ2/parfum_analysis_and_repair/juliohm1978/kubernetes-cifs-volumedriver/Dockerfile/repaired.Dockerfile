FROM golang:1.16.3 AS build-env
ARG TARGETOS
ARG TARGETARCH
ENV GOOS=${TARGETOS}
ENV GOARCH=${TARGETARCH}

RUN apt-get update && apt-get install --no-install-recommends -y git gcc && rm -rf /var/lib/apt/lists/*;
ADD . /kubernetes-cifs-volumedriver
WORKDIR /kubernetes-cifs-volumedriver

## Running these in separate steps gives a better error
## output indicating which one actually failed.
RUN go build -a -installsuffix cgo
RUN go test

FROM busybox:1.32.0

ENV VENDOR=juliohm
ENV DRIVER=cifs

COPY --from=build-env /kubernetes-cifs-volumedriver/kubernetes-cifs-volumedriver /
COPY install.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/install.sh

CMD ["/usr/local/bin/install.sh"]
