FROM cargo.caicloud.xyz/library/debian:stretch

RUN echo "Asia/Shanghai" > /etc/timezone

RUN mkdir /data

COPY bin/registry /registry

COPY build/registry/config.yaml /config.yaml

ENTRYPOINT ["/registry"]
CMD ["serve", "-c", "/config.yaml"]