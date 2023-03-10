FROM debian:8

RUN apt-get update --fix-missing && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y libzmq3 \
                      libpqxx-4.0 \
                      libgoogle-perftools4 \
                      libprotobuf9 \
                      libproj-dev \
                      protobuf-compiler \
                      libgeos-c1 \
                      liblog4cplus-1.0-4 \
                      libboost-chrono1.55.0 \
                      libboost-date-time1.55.0 \
                      libboost-filesystem1.55.0 \
                      libboost-iostreams1.55.0 \
                      libboost-program-options1.55.0 \
                      libboost-regex1.55.0 \
                      libboost-serialization1.55.0 \
                      libboost-system1.55.0 \
                      libboost-test1.55.0 \
                      libboost-thread1.55.0 \
                      netcat && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /srv/kraken
COPY tests/mock-kraken/*_test /srv/kraken/
WORKDIR /srv/kraken
EXPOSE 30000
ENV KRAKEN_GENERAL_zmq_socket=tcp://*:30000
ENV KRAKEN_GENERAL_log_level=INFO
