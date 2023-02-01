FROM ubuntu:14.04
RUN apt-get update && apt-get dist-upgrade -y -qq
RUN apt-get install --no-install-recommends -y -qq apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -qq curl && \
 curl -f -L https://packagecloud.io/varnishcache/varnish41/gpgkey | sudo apt-key add - && \
echo "deb https://packagecloud.io/varnishcache/varnish41/ubuntu/ trusty main" \
>> /etc/apt/sources.list.d/varnishcache_varnish41.list && \
echo "deb-src https://packagecloud.io/varnishcache/varnish41/ubuntu/ trusty main" \
>> /etc/apt/sources.list.d/varnishcache_varnish41.list && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN apt-get install --no-install-recommends -y -qq varnish && rm -rf /var/lib/apt/lists/*;
COPY default.vcl /etc/varnish/default.vcl
COPY start /start
RUN chmod 0755 /start
CMD ["/start"]