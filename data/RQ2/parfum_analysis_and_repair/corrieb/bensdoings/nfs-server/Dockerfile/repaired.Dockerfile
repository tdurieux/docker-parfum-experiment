FROM debian

RUN apt-get update && \
    apt-get install --no-install-recommends -yy procps kmod nfs-kernel-server && \
    mkdir /run/sendsigs.omit.d && rm -rf /var/lib/apt/lists/*;

CMD [ "/etc/rc.local" ]

COPY rc.local /etc/
