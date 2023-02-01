FROM BASEIMAGE

RUN apk add --no-cache --update \
    iperf3 \
  && rm -rf /var/cache/apk/*

EXPOSE 5201

ENTRYPOINT ["/usr/bin/iperf3"]

CMD ["--server","-p","5201"]
