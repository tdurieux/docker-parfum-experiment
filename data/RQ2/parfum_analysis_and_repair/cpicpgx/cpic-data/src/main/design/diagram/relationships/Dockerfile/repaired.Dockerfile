FROM ubuntu:17.04

MAINTAINER "Ryan Whaley" whaleyr@pharmgkb.org

WORKDIR /app

ADD . /app

# update
RUN apt-get -y update && apt-get -y --no-install-recommends install graphviz && rm -rf /var/lib/apt/lists/*;

CMD ["dot", "-Tpng", "diagram.dot"]
