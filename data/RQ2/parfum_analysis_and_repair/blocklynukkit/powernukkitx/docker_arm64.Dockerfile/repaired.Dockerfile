FROM arm64v8/openjdk:8-jdk-slim AS build
WORKDIR /usr/local/src/nukkit
COPY src /usr/local/src/nukkit/src
COPY mvn* pom.xml /usr/local/src/nukkit/
COPY .git /usr/local/src/nukkit/.git
COPY .mvn /usr/local/src/nukkit/.mvn
COPY .gitmodules /usr/local/src/nukkit/.gitmodules
RUN apt-get -y update && \
    apt-get install --no-install-recommends -y build-essential git maven && \
    git submodule update --init && \
    mvn clean package && rm -rf /var/lib/apt/lists/*;

FROM arm64v8/openjdk:8-jre-slim AS run
LABEL maintainer="Chris Fordham <chris@fordham.id.au>"
COPY --from=build /usr/local/src/nukkit/target/nukkit-1.0-SNAPSHOT.jar /opt/nukkit/nukkit.jar
COPY release-script/nukkit.default.yml /etc/opt/nukkit/nukkit.yml
RUN useradd --user-group \
            --no-create-home \
            --home-dir /var/opt/nukkit \
            --shell /usr/sbin/nologin \
              minecraft && \
    mkdir -p /var/opt/nukkit && \
    chown -R minecraft /opt/nukkit /var/opt/nukkit /etc/opt/nukkit/nukkit.yml && \
    ln -sfv /etc/opt/nukkit/nukkit.yml /var/opt/nukkit/nukkit.yml && \
    apt-get -y update && \
    apt-get -y --no-install-recommends install lsof && \
    rm -rf /var/lib/apt/lists/*
USER minecraft
VOLUME /etc/opt/nukkit /var/opt/nukkit /opt/nukkit
EXPOSE 19132
WORKDIR /var/opt/nukkit
ENTRYPOINT ["java"]
CMD [ "-jar", "/opt/nukkit/nukkit.jar" ]
