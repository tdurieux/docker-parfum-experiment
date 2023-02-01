FROM ubuntu:18.04 as build

RUN set -ex && \
    apt-get update && \
    apt-get install --no-install-recommends -y build-essential && \
    apt-get install --no-install-recommends -y libboost-all-dev && \
    apt-get install --no-install-recommends -y libssl-dev && \
    apt-get install --no-install-recommends -y g++ && \
    apt-get install --no-install-recommends -y make && \
    apt-get install --no-install-recommends -y git && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

RUN cd /opt && git clone https://github.com/jselbie/stunserver.git && cd stunserver && make

FROM ubuntu:18.04

EXPOSE 3478/tcp 3478/udp

RUN apt update && apt install -y --no-install-recommends libssl1.1 && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN mkdir /opt/stunserver
COPY --from=build /opt/stunserver/stunclient /opt/stunserver/stunclient
COPY --from=build /opt/stunserver/stunserver /opt/stunserver/stunserver

WORKDIR /opt/stunserver

HEALTHCHECK CMD /opt/stunserver/stunclient localhost

ENTRYPOINT ["/opt/stunserver/stunserver"]


