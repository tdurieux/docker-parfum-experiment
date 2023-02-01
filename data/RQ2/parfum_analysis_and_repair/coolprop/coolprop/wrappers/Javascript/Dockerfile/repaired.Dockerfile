## Use docker-compose to spin up this job

FROM emscripten/emsdk

RUN apt-get -y -m update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y dos2unix && rm -rf /var/lib/apt/lists/*;

COPY build.sh /build.sh
RUN dos2unix /build.sh

WORKDIR /
CMD bash /build.sh