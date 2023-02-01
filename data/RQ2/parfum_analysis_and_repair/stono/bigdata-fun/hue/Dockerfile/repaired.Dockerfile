FROM gethue/hue:latest
MAINTAINER Karl Stoney <me@karlstoney.com>

RUN apt-get -y --no-install-recommends -q install curl && rm -rf /var/lib/apt/lists/*;

HEALTHCHECK CMD curl -f http://localhost:8888/ || exit 1

COPY pseudo-distributed.ini /hue/desktop/conf/pseudo-distributed.ini
