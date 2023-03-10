FROM ubuntu:xenial-20210804

ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install \
        xinetd \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --no-create-home cooldown && mkdir -p /home/cooldown

COPY ./src /home/cooldown/
COPY ./app.xinetd /etc/xinetd.d/app
COPY ./src/flag.txt /

RUN chown -R root:root /home && \
    find /home -type d -exec chmod 555 {} \; && \
    find /home -type f -exec chmod 444 {} \;

RUN chmod +x /home/cooldown/chall

WORKDIR /home/cooldown
EXPOSE 1337

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/sbin/xinetd","-dontfork"]
