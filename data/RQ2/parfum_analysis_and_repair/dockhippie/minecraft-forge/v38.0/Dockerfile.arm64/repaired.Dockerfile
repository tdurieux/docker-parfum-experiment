FROM webhippie/minecraft-vanilla:1.18-arm64@sha256:54a30dcf500c4d86177ff7d79114049617b449c36b38a8dca7b4086f67bbea22

EXPOSE 25565 25575

ENV FORGE_VERSION 38.0.17
ENV FORGE_URL https://maven.minecraftforge.net/net/minecraftforge/forge/${MINECRAFT_VERSION}-${FORGE_VERSION}/forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-installer.jar

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends -y libatomic1 && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  curl -f --create-dirs -sLo /usr/share/minecraft/forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-installer.jar ${FORGE_URL} && \
  cd /usr/share/minecraft && \
  mkdir mods && \
  java -jar forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-installer.jar --installServer && \
  rm -f forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-installer.jar forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-installer.jar.log run.bat run.sh

COPY ./overlay /
