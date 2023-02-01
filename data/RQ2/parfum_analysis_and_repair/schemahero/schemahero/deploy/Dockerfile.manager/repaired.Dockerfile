FROM ubuntu:latest

RUN apt-get update -y && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

WORKDIR /
COPY ./bin/manager /manager
RUN chmod a+x /manager

RUN useradd -c 'schemahero-manager user' -m -d /home/schemahero-manager -s /bin/bash -u 1001 schemahero-manager
USER schemahero-manager
ENV HOME /home/schemahero-manager

ENTRYPOINT ["/manager", "run"]
