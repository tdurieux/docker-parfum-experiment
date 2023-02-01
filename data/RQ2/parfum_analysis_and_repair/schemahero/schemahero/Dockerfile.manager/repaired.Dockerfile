# Copy schemahero into a thin image
FROM debian:buster
WORKDIR /

RUN apt-get update \
 && apt-get -y --no-install-recommends install \
    ca-certificates && rm -rf /var/lib/apt/lists/*;

ADD ./bin/manager /manager

RUN useradd -c 'schemahero user' -m -d /home/schemahero -s /bin/bash -u 1001 schemahero
USER 1001
ENV HOME /home/schemahero

ENTRYPOINT ["/manager", "run"]
