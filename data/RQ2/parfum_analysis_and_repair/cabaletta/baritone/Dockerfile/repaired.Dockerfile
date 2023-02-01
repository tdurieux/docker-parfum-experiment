FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive

RUN apt update -y && apt install -y --no-install-recommends \
          openjdk-8-jdk \
          --assume-yes && rm -rf /var/lib/apt/lists/*;

COPY . /code

WORKDIR /code

RUN ./gradlew build
