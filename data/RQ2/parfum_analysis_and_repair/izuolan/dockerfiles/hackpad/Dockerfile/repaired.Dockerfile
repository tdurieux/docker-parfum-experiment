FROM ubuntu:14.04

RUN apt-get -y update && apt-get install --no-install-recommends -yf \
    openjdk-7-jdk \
    mysql-server \
    scala && rm -rf /var/lib/apt/lists/*;

RUN mkdir /etc/hackpad

VOLUME /etc/hackpad/src

COPY docker-entrypoint.sh /etc/hackpad/

ENTRYPOINT ["/etc/hackpad/docker-entrypoint.sh"]

EXPOSE 9000

CMD ["hackpad"]
