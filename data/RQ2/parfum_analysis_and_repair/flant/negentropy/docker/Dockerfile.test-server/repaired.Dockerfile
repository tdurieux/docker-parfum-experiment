FROM --platform=linux/amd64 ubuntu:20.04

COPY wrapper.sh /opt

RUN apt-get update && \
    apt-get install openssh-server --no-install-recommends -y && rm -rf /var/lib/apt/lists/*;

CMD /opt/wrapper.sh
