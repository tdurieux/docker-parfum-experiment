FROM webhippie/minecraft-vanilla:1.14.2-arm64@sha256:5f9da60d9deafc7e0ee73e669301e1d5e0114a84e739fd539c82537dc106c7c2

EXPOSE 25565 25575

ENV FORGE_VERSION 26.0.63
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

COPY ./overlay /
