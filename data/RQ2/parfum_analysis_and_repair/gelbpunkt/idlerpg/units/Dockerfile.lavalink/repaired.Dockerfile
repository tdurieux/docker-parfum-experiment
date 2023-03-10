FROM fedora-minimal:32

RUN microdnf install java-13-openjdk-headless -y && \
    microdnf clean all && \
    useradd -M lavalink && \
    usermod -L lavalink

USER lavalink
WORKDIR /lavalink

RUN curl -f -L https://ftp.travitia.xyz/Lavalink.jar -o Lavalink.jar

CMD java -jar Lavalink.jar -Xms8G -Xmx8G
