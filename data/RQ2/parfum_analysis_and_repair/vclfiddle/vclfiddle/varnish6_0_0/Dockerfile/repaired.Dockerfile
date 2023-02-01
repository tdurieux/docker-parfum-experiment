FROM ubuntu:16.04
LABEL maintainer "vclfiddle.net <support@vclfiddle.net>"

RUN apt-get update && \
  apt-get install -y --assume-yes --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl && rm -rf /var/lib/apt/lists/*;

RUN printf 'deb https://packagecloud.io/varnishcache/varnish60/ubuntu/ xenial main\n' >/etc/apt/sources.list.d/varnish.list && \
  curl -f -L https://packagecloud.io/varnishcache/varnish60/gpgkey | apt-key add - && \
  apt-get update && \
  apt-get install -y --assume-yes --no-install-recommends \
    varnish=6.0.0-* && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --assume-yes --no-install-recommends netcat-openbsd && rm -rf /var/lib/apt/lists/*;

VOLUME ["/fiddle"]
CMD ["/bin/bash", "/run.sh"]
ADD run.sh /run.sh
