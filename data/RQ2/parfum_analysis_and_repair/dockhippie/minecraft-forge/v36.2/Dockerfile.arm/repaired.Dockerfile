FROM webhippie/minecraft-vanilla:1.16.5-arm@sha256:c822d1e8e1d72cc2d0d4245e61ee3467310696c202e3c0be65e5ae606feb413d

EXPOSE 25565 25575 8123

ENV FORGE_VERSION 36.2.2
ENV FORGE_JAR forge-${MINECRAFT_VERSION}-${FORGE_VERSION}.jar
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
  rm -f forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-installer.jar forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-installer.jar.log

ENV DYNMAP_VERSION 3.2-beta-2
ENV DYNMAP_JAR Dynmap-${DYNMAP_VERSION}-forge-${MINECRAFT_VERSION}.jar
ENV DYNMAP_URL https://media.forgecdn.net/files/3369/672/${DYNMAP_JAR}

RUN curl -f --create-dirs -sLo /usr/share/minecraft/optionals/${DYNMAP_JAR} ${DYNMAP_URL}

COPY ./overlay /
