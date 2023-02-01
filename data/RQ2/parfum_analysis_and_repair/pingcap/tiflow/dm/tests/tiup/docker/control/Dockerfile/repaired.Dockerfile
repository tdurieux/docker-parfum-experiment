FROM golang:1.16

RUN apt-get -y -q update && \
    apt-get -y --no-install-recommends -q install software-properties-common && \
    apt-get install --no-install-recommends -qqy \
        default-mysql-client \
        psmisc && rm -rf /var/lib/apt/lists/*;

ADD bashrc /root/.bashrc
ADD init.sh /init.sh
RUN chmod +x /init.sh && \
    mkdir -p /root/.ssh && \
    echo "Host *\n    ServerAliveInterval 30\n    ServerAliveCountMax 3" >> /root/.ssh/config

CMD /init.sh
