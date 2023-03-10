FROM vipconsult/base:jessie
MAINTAINER Vip Consult Solutions <team@vip-consult.solutions>

RUN apt-get install -y --no-install-recommends locales mysql-client-5.5 && rm -rf /var/lib/apt/lists/*;

RUN echo "en_GB.UTF-8 UTF-8" >> /etc/locale.conf && \
    echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen && \

    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV HOME /root

ENTRYPOINT ["/usr/bin/mysql"]
