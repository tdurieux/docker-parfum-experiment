FROM ubuntu:20.04

RUN apt-get update -y && apt-get install --no-install-recommends -y build-essential uuid-dev libssl-dev git && rm -rf /var/lib/apt/lists/*;

RUN git clone --branch v1.0.1 https://github.com/redis/hiredis
RUN cd hiredis && make && make install

WORKDIR /data
COPY ./selva /data/selva
COPY ./locale /data/locale
ENV LOCPATH="/data/locale.build"

CMD cd /data/selva && make -j4 && cp ./module.so /dist/selva.so; \
    cd /data/locale && make -j4 && \
    cd "$LOCPATH" && find "./" -type f -exec install -D "--group=$DOCKER_GROUP" "--owner=$DOCKER_USER" "{}" "/locale/{}" \;
