FROM ubuntu:trusty

LABEL version="1.0" \
      description="Bot 2.0.0 docker-bot" \
      maintainer="Gaston Lopez <lopez.gaston.1996@gmail.com>"

RUN apt-get update && \
  apt-get install --no-install-recommends -y curl && \
  apt-get install --no-install-recommends -y hping3 && rm -rf /var/lib/apt/lists/*;

WORKDIR /root

CMD ["bash"]
