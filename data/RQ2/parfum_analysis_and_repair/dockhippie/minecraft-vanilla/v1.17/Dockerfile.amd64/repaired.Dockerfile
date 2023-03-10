FROM webhippie/temurin:17-amd64@sha256:c28e530b940db82c2f6a90c2be1f3b5c276ac62b1fd09f9d6a844490779c1895 as build

# renovate: datasource=github-releases depName=itzg/rcon-cli
ENV RCONCLI_VERSION=1.4.8

RUN curl -f -sSLo - "https://github.com/itzg/rcon-cli/releases/download/${RCONCLI_VERSION}/rcon-cli_${RCONCLI_VERSION}_linux_amd64.tar.gz" | tar -xvz -C /tmp

FROM webhippie/temurin:17-amd64@sha256:c28e530b940db82c2f6a90c2be1f3b5c276ac62b1fd09f9d6a844490779c1895

VOLUME ["/var/lib/minecraft", "/etc/minecraft/override"]
EXPOSE 25565 25575

WORKDIR /var/lib/minecraft
CMD ["/usr/bin/container"]

ENV MINECRAFT_VERSION 1.17
ENV MINECRAFT_JAR minecraft_server.${MINECRAFT_VERSION}.jar
ENV MINECRAFT_URL https://launcher.mojang.com/v1/objects/0a269b5f2c5b93b1712d0f5dc43b6182b9ab254e/server.jar

RUN curl -f --create-dirs -sLo /usr/share/minecraft/${MINECRAFT_JAR} ${MINECRAFT_URL}

RUN apt-get update && \
  apt-get upgrade -y && \
  groupadd -g 1000 minecraft && \
  useradd -u 1000 -d /var/lib/minecraft -g minecraft -s /bin/bash -M minecraft && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/**

COPY --from=build /tmp/rcon-cli /usr/bin/rcon-cli
COPY ./overlay /
