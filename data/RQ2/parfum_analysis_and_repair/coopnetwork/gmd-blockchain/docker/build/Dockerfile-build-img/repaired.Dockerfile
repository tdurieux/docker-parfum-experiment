FROM openjdk:16-bullseye

RUN apt-get update && apt-get install --no-install-recommends -y \
  docker.io \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /output/
RUN mkdir -p /scripts/
RUN mkdir -p /srcgmd/
RUN mkdir -p /output-docker-image/
RUN mkdir -p /docker-image/

COPY ./ /srcgmd/
COPY docker/build/Dockerfile-runtime /docker-image/Dockerfile
COPY docker/run-docker-node/docker-compose.yml /docker-image/docker-compose.yml
COPY docker/run-docker-node/docker-compose-rproxy.yml /docker-image/docker-compose-rproxy.yml


ADD ./docker/build/build.sh /scripts/build.sh
CMD bash /scripts/build.sh dockerimg
