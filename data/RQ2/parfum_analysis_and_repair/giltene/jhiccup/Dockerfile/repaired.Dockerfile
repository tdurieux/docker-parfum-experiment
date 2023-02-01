FROM azul/zulu-openjdk:8

RUN apt-get update && apt-get -qqy --no-install-recommends install maven && rm -rf /var/lib/apt/lists/*;
