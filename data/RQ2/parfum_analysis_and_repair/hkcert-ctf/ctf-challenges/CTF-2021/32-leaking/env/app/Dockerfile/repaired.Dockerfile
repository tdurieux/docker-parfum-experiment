FROM ubuntu:bionic-20210930

ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install \
        xinetd \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --no-create-home leaking && mkdir -p /home/leaking

COPY ./src /home/leaking/
COPY ./app.xinetd /etc/xinetd.d/app

RUN chown -R root:root /home && \
    find /home -type d -exec chmod 555 {} \; && \
    find /home -type f -exec chmod 444 {} \;

RUN chmod +x /home/leaking/chall

WORKDIR /home/leaking
EXPOSE 1337

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/sbin/xinetd","-dontfork"]
