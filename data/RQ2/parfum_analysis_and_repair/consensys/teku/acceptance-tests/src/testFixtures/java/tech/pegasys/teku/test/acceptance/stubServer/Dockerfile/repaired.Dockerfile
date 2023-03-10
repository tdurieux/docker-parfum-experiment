FROM eclipse-temurin:17
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH "${JAVA_HOME}/bin:${PATH}"

COPY . /opt/tech/pegasys/teku/test/acceptance/stubServer/

RUN apt-get -y update && apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/api/lists/*

WORKDIR /opt/tech/pegasys/teku/test/acceptance/stubServer/

EXPOSE 8001

RUN javac /opt/tech/pegasys/teku/test/acceptance/stubServer/*.java -d bin

CMD java -cp bin tech.pegasys.teku.test.acceptance.stubServer.StubServer

