FROM webhippie/minecraft-vanilla:1.14.3-amd64@sha256:2a4303cdbf702524870fbc2a9630644179cff032beceb64212903b7db1fac98e

EXPOSE 25565 25575

ENV FORGE_VERSION 27.0.60
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
