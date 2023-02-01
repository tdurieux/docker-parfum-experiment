FROM ubuntu:18.04
RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates && \
    rm -f /bin/sh && ln -s /bin/bash /bin/sh && rm -rf /var/lib/apt/lists/*;
COPY bin/rdns-server /usr/bin/
CMD ["rdns-server"]
