FROM openjdk:8
RUN mkdir /brc
ADD https://github.com/Pugmatt/BedrockConnect/releases/latest/download/BedrockConnect-1.0-SNAPSHOT.jar /brc
WORKDIR /brc
EXPOSE 19132/udp
CMD ["java", "-Xms1G", "-Xmx1G", "-jar", "BedrockConnect-1.0-SNAPSHOT.jar","nodb=true", "custom_servers=/brc/custom_servers.json"]
