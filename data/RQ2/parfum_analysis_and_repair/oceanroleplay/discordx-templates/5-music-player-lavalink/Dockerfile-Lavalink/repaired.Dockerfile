FROM ubuntu as getter

# Install required tools
RUN apt-get update && apt-get install --no-install-recommends curl wget -y && rm -rf /var/lib/apt/lists/*;

# Set workdir
WORKDIR /opt/Lavalink

# Download latest lavalink
RUN curl -f -s https://api.github.com/repos/freyacodes/Lavalink/releases/latest \
    | grep https://github.com/freyacodes/Lavalink/releases/download/.*/Lavalink.jar \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -qi -

FROM openjdk

# Run as non-root user
RUN groupadd -g 322 lavalink && useradd -r -u 322 -g lavalink lavalink
USER lavalink

# Set workdir
WORKDIR /opt/Lavalink

# Copy lavalink
COPY --from=getter /opt/Lavalink/Lavalink.jar  Lavalink.jar

# Add config file
ADD application.yml .

# Note: configure ram usage with -Xmx
ENTRYPOINT ["java", "-Djdk.tls.client.protocols=TLSv1.1,TLSv1.2", "-Xmx1G", "-jar", "Lavalink.jar"]