FROM adoptopenjdk:15-jre-hotspot
MAINTAINER John Paul Alcala jp@jpalcala.com

# Taken from Postgres Official Dockerfile.
# grab gosu for easy step-down from root
RUN apt-get update && apt-get install --no-install-recommends -y curl rsync tmux gpg jq && rm -rf /var/lib/apt/lists/* \
    && gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -f -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
    && curl -f -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
    && gpg --batch --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu

RUN groupadd -g 1000 minecraft && \
    useradd -g minecraft -u 1000 -r -M minecraft && \
    touch /run/first_time && \
    mkdir -p /opt/minecraft /usr/src/minecraft && \
    echo "set -g status off" > /root/.tmux.conf && rm -rf /opt/minecraft

COPY minecraft /usr/local/bin/
ONBUILD COPY . /usr/src/minecraft

EXPOSE 25565

ENTRYPOINT ["/usr/local/bin/minecraft"]
CMD ["run"]
