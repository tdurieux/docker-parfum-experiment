FROM ubuntu:20.04

ADD ./pando-server /opt/pando-server
ADD start.sh /opt/start.sh

RUN apt-get -qq update &&\
    apt-get -qq install -y --no-install-recommends ca-certificates curl && \
    chmod +x /opt/pando-server && rm -rf /var/lib/apt/lists/*;

CMD bash /opt/start.sh
