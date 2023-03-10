# mostly from https://github.com/AdoptOpenJDK/openjdk-docker/blob/c945a5b588b63553a7bb36c28b6751716e35070c/8/jre/debian/Dockerfile.hotspot.releases.full
# with exception of adding libatomic1 & botdarr setup
FROM debian:buster-slim

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN apt-get update \
    && apt-get install -y --no-install-recommends tzdata curl ca-certificates fontconfig locales libatomic1 \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_VERSION jdk8u292-b10

# c_rehash due to some weird case where I can't make outbound ssl requests
RUN c_rehash; \
    curl -LfsSo /tmp/openjdk.tar.gz https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u292-b10/OpenJDK8U-jre_arm_linux_hotspot_8u292b10.tar.gz; \
    echo "7f7707a7a3998737d2221080ea65d50ea96f5dde5226961ebcebd3ec99a82a32  */tmp/openjdk.tar.gz" | sha256sum -c -; \
    mkdir -p /opt/java/openjdk; \
    cd /opt/java/openjdk; \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
    rm -rf /tmp/openjdk.tar.gz;

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"

RUN mkdir -p /home/botdarr
ADD target/botdarr-release.jar /home/botdarr

WORKDIR /home/botdarr

COPY ./docker/entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
CMD ["java", "-jar", "botdarr-release.jar"]