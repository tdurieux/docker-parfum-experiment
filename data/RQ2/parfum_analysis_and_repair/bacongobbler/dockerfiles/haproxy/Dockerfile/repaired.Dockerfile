FROM        ubuntu
MAINTAINER  Matthew Fisher <me@bacongobbler.com>

RUN apt-get update && apt-get install --no-install-recommends -yq haproxy && rm -rf /var/lib/apt/lists/*;

RUN echo "ENABLED=1" > /etc/default/haproxy
ADD haproxy.cfg /etc/haproxy/haproxy.cfg

EXPOSE  80 9000

CMD haproxy -f /etc/haproxy/haproxy.cfg
