FROM y12docker/kotlin-gradle:3.3
RUN apt-get update ; apt-get install --no-install-recommends -y openjfx curl jq \
    && git clone --depth=1 https://github.com/corda/corda /corda && rm -rf /var/lib/apt/lists/*;
WORKDIR /corda
RUN ./gradlew wrapper --gradle-version 2.10
RUN ./gradlew build --info
