FROM ubuntu:18.04

ARG CHALL

WORKDIR /

ENV CHALLENGE_USER=${CHALL}
ENV CHALLENGE=${CHALL}

RUN apt-get update && apt-get install --no-install-recommends -y lighttpd iputils-ping && rm -rf /var/lib/apt/lists/*;
RUN useradd -m ${CHALLENGE_USER}
RUN sed -i 's/www-data/simpleweb/g' /etc/init.d/lighttpd
RUN chown -R simpleweb:simpleweb /var/log/lighttpd
RUN chown -R simpleweb:simpleweb /var/cache/lighttpd/compress

EXPOSE 80

COPY ./lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY ./init.sh /init.sh

RUN chmod 755 /init.sh

ENTRYPOINT [ "/init.sh" ]