FROM debian:stable
MAINTAINER Eugene Zilman <ezilman@gmail.com>

RUN apt-get clean && apt update && apt install -y

RUN apt install --no-install-recommends -y kernel-package && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y git build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y distcc distcc-pump && rm -rf /var/lib/apt/lists/*;

COPY config /etc/default/distcc
COPY runner.sh /runner.sh

ENTRYPOINT ["/runner.sh"]

