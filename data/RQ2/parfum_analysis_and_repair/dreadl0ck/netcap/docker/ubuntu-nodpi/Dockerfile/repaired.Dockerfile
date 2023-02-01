FROM ubuntu:18.04 as builder
RUN apt-get clean
RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:longsleep/golang-backports
RUN apt-get update
RUN apt-get install --no-install-recommends -y golang-go && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y apt-transport-https curl lsb-release wget autogen autoconf libtool gcc libpcap-dev linux-headers-generic git vim && rm -rf /var/lib/apt/lists/*;

WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
ENV VERSION XXX
ARG TAGS
RUN echo "tags: $TAGS"

RUN echo go build -mod=readonly ${TAGS} -ldflags "-s -w -X github.com/dreadl0ck/netcap.Version=v${VERSION}" -o /netcap/bin/net github.com/dreadl0ck/netcap/cmd
RUN go build -mod=readonly ${TAGS} -ldflags "-s -w -X github.com/dreadl0ck/netcap.Version=v${VERSION}" -o /netcap/bin/net github.com/dreadl0ck/netcap/cmd

#RUN ls -la /usr/lib/

FROM ubuntu:18.04
ARG IPV6_SUPPORT=true
RUN apt-get update
RUN apt install --no-install-recommends -y --fix-missing libpcap-dev software-properties-common ca-certificates liblzo2-2 libkeyutils-dev git-lfs && rm -rf /var/lib/apt/lists/*;
RUN update-ca-certificates
WORKDIR /netcap
COPY --from=builder /netcap/bin/* /usr/bin/
#COPY --from=builder /usr/lib/* /usr/lib/
COPY --from=builder /usr/local/lib/* /usr/lib/
CMD ["/bin/sh"]
