FROM webhippie/minecraft-vanilla:1.15.1-arm64@sha256:95e43aaa546ff0c5bd257a7774b62b99cf6604a7cf892616bef41b591ed2691f

EXPOSE 25565 25575 8123

ENV FORGE_VERSION 30.0.51
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
ENV DYNMAP_URL https://media.forgecdn.net/files/3369/650/${DYNMAP_JAR}

RUN curl -f --create-dirs -sLo /usr/share/minecraft/optionals/${DYNMAP_JAR} ${DYNMAP_URL}

COPY ./overlay /
