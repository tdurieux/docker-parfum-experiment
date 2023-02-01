FROM debian:stretch
MAINTAINER Christian Lück <christian@lueck.tv>

RUN apt-get update && \
    apt-get install -y --no-install-recommends streamripper && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /home/streamripper streamripper
USER streamripper
WORKDIR /home/streamripper

# expose relay port
EXPOSE 8000

ADD run.sh /run.sh
ENTRYPOINT ["/run.sh"]
VOLUME /home/streamripper
