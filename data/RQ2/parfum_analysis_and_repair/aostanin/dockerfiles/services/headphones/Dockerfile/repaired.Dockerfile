FROM ubuntu:trusty

ENV LANG en_US.UTF-8
RUN locale-gen $LANG

RUN apt-get update -q && \
    apt-get install --no-install-recommends -qy git-core python2.7 && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/rembo10/headphones.git /headphones

ADD start.sh /start.sh

VOLUME ["/data"]
EXPOSE 8181

CMD ["/start.sh"]
