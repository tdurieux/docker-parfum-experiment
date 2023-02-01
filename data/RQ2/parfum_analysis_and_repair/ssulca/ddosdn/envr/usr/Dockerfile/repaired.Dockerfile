FROM ubuntu:trusty

LABEL version="1.0" \
      description="User 1.0.0 docker-monitoring" \
      maintainer="Gaston Lopez <lopez.gaston.1996@gmail.com>"

RUN apt-get update && \
  apt-get install --no-install-recommends -y curl && \
  apt-get install --no-install-recommends -y siege && \
  apt-get install --no-install-recommends -y iproute2 && rm -rf /var/lib/apt/lists/*;

WORKDIR /root
ADD files /root

CMD ["siege -c5 -t 2H -i -f urls.txt"]
