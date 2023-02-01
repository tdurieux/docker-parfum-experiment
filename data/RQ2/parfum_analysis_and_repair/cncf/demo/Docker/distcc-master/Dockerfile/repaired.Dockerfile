FROM zilman/kernel
MAINTAINER Eugene Zilman <ezilman@gmail.com>

RUN apt-get install --no-install-recommends -y distcc distcc-pump && rm -rf /var/lib/apt/lists/*;

COPY config /etc/default/distcc
COPY runner.sh /runner.sh

ENTRYPOINT ["/runner.sh"]

