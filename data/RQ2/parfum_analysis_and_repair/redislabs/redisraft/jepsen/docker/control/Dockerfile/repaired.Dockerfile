FROM debian:stretch

#
# Jepsen dependencies
#
RUN apt-get -y -q update && \
    apt-get install --no-install-recommends -qqy \
        openjdk-8-jre \
        libjna-java \
        git \
        gnuplot \
        wget \
	vim \
        graphviz && rm -rf /var/lib/apt/lists/*;

ENV LEIN_ROOT true
RUN wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
    mv lein /usr/bin && \
    chmod +x /usr/bin/lein && \
    lein self-install

ARG JEPSEN_REPO=redislabs/jepsen-redisraft
RUN git clone https://github.com/${JEPSEN_REPO} /jepsen && \
    cd /jepsen && \
    lein install

ADD entrypoint.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
