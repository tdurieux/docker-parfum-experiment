FROM navitia/master

# copy package from context inside the docker
COPY mock-kraken_*.deb ./

RUN apt-get update \
    && apt install --no-install-recommends -y ./mock-kraken_*.deb \
    && apt-get clean \
    && rm -rf mock-kraken_*.deb && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /srv/kraken \
    && ln -s /usr/bin/main_routing_test /srv/kraken/main_routing_test \
    && ln -s /usr/bin/departure_board_test /srv/kraken/departure_board_test

WORKDIR /srv/kraken
EXPOSE 30000
ENV KRAKEN_GENERAL_zmq_socket=tcp://*:30000
ENV KRAKEN_GENERAL_log_level=INFO
