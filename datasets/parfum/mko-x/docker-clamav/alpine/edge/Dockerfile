FROM alpine:20220328
LABEL maintainer="https://mko-x.github.io/docker-clamav/"

RUN apk add --no-cache bash clamav clamav-libunrar

COPY conf /etc/clamav
COPY bootstrap.sh /
COPY envconfig.sh /
COPY check.sh /

RUN mkdir /var/run/clamav && \
    chown clamav:clamav /var/run/clamav && \
    chmod 750 /var/run/clamav && \
    chown -R clamav:clamav bootstrap.sh check.sh /etc/clamav && \
    chmod u+x bootstrap.sh check.sh 

EXPOSE 3310/tcp

USER clamav

CMD ["/bootstrap.sh"]
