FROM ubuntu:14.04
LABEL maintainer "vclfiddle.net <support@vclfiddle.net>"

RUN apt-get update && \
  apt-get install -y --assume-yes --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl && rm -rf /var/lib/apt/lists/*;

RUN printf 'deb https://packagecloud.io/varnishcache/varnish5/ubuntu/ trusty main\n' >/etc/apt/sources.list.d/varnish.list && \
  curl -f -L https://packagecloud.io/varnishcache/varnish5/gpgkey | apt-key add - && \
  apt-get update && \
  apt-get install -y --assume-yes --no-install-recommends \
    varnish=5.1.2-1 && rm -rf /var/lib/apt/lists/*;

VOLUME ["/fiddle"]
CMD ["/run.sh"]
ADD run.sh /run.sh
