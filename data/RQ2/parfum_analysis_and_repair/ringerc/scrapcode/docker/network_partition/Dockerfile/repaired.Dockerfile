FROM debian:10
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install iproute2 socat iptables && rm -rf /var/lib/apt/lists/*;
ADD server /usr/local/bin/server
ADD client /usr/local/bin/client
RUN chmod a+x /usr/local/bin/server /usr/local/bin/client
