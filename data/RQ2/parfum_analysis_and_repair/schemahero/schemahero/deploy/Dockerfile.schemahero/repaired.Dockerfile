FROM debian:buster
WORKDIR /
COPY ./bin/kubectl-schemahero /schemahero
RUN chmod a+x /schemahero

RUN apt-get -qq update \
 && apt-get -qq --no-install-recommends -y install \
    ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN useradd -c 'schemahero user' -m -d /home/schemahero -s /bin/bash -u 1001 schemahero
USER schemahero
ENV HOME /home/schemahero

ENTRYPOINT ["/schemahero"]
