FROM statemood/alpine:3.7

COPY job.sh         /

RUN apk update		&& \
    apk upgrade		&& \
    c="gcc make autoconf g++ python2-dev mysql-dev" && \
    pi="mirrors.aliyun.com"                         && \
    ps="http://$pi/pypi/simple"                     && \
    args="-i $ps --trusted-host=$pi" && \
    apk add --no-cache "python2~=2.7.14" py2-pip $c jq && \
    pip install --no-cache-dir --upgrade pip $args && \
    pip install --no-cache-dir ssh toml MySQL-python==1.2.5 $args && \
    cp /usr/lib/libmysqlclient.so.18 / && \
    apk del $c && \
    mv /libmysqlclient.so.18 /usr/lib && \
    chmod 755 /job.sh