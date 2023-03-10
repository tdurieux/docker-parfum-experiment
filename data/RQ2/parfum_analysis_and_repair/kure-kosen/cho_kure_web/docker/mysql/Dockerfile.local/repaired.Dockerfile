FROM mysql:5.7

ADD log.cnf /etc/mysql/conf.d/log.cnf
ADD my.cnf /etc/mysql/conf.d/my.cnf

RUN chmod 644 /etc/mysql/conf.d/log.cnf

RUN apt-get update && apt-get install -y locales \
  --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN dpkg-reconfigure locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8

# 初期データベースの作成
COPY init.d/ /docker-entrypoint-initdb.d/

ENV LC_ALL C.UTF-8
ENV TERM xterm