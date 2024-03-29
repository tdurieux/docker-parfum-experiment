FROM nsqio/nsq:v1.0.0-compat

FROM debian:buster-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    \
    \
    libp11-kit0 \
  && apt-get clean \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/*

EXPOSE 4150 4151 4160 4161 4170 4171

VOLUME /data
VOLUME /etc/ssl/certs

COPY --from=0 /usr/local/bin/ /usr/local/bin/

RUN ln -s /usr/local/bin/*nsq* / \
    && ln -s /usr/local/bin/*nsq* /bin/

RUN chmod a+rwx /tmp /home /run /var
WORKDIR /home