THIS IS JUST DRAFT!!!

FROM ubuntu:16.04 as builder
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update && apt-get dist-upgrade -y  && apt-get install -qq --no-install-recommends --allow-unauthenticated -y \
  openjdk-8-jdk \
  openjfx \
  python3-pip \
  maven \
  git-all \
  && mkdir code && rm -rf /var/lib/apt/lists/*;
RUN wget latest https://github.com/eficode/JavaFXLibrary/releases Source code.zip && unzip
WORKDIR /code
RUN mvn package

FROM ubuntu:16.04
RUN apt-get -qq update && apt-get dist-upgrade -y  && apt-get install -qq --no-install-recommends --allow-unauthenticated -y \
  openjdk-8-jre \
  openjfx \
  && rm -rf /var/lib/apt/lists/*
COPY --from=builder /code/target/JAVAFX:n testisoftat
RUN wget https://github.com/eficode/JavaFXLibrary/releases JavaFXLibrary-0.4.1.jar
EXPOSE 8270
ENTRYPOINT java -jar JavaFXLibrary-0.4.1.jar jolle sisäään myös testisofta jarrit class pathinä/etc?
