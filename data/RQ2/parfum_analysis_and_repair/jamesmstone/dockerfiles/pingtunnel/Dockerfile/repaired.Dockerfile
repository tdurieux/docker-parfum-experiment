# See http://www.cs.uit.no/~daniels/PingTunnel/
#FROM alpine:latest
#RUN apk add -U --no-cache alpine-sdk
#RUN wget -qO- http://www.cs.uit.no/~daniels/PingTunnel/PingTunnel-0.72.tar.gz | tar xvz
#WORKDIR /PingTunnel
#RUN make install
#FROM debian:latest
#RUN echo "deb http://www.cti.ecp.fr/~beauxir5/debian binary/" >> /etc/apt/sources.list && \
#echo "deb-src http://www.cti.ecp.fr/~beauxir5/debian source/" >/etc/apt/sources.list && \
#apt-get update && apt-get install ptunnel -y

FROM ubuntu:latest
RUN apt-get update && apt-get install --no-install-recommends -y build-essential wget libpcap0.8-dev && rm -rf /var/lib/apt/lists/*;
RUN wget -qO- https://www.cs.uit.no/~daniels/PingTunnel/PingTunnel-0.72.tar.gz | tar xvz
WORKDIR /PingTunnel
RUN make install

ENTRYPOINT ["ptunnel"]
