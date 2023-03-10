FROM envoyproxy/envoy-dev:latest
ADD ./lib/mylibrary.lua /lib/mylibrary.lua
COPY ./envoy.yaml /etc/envoy.yaml
RUN chmod go+r /etc/envoy.yaml /lib/mylibrary.lua
CMD ["/usr/local/bin/envoy", "-c", "/etc/envoy.yaml", "-l", "debug", "--service-cluster", "proxy"]