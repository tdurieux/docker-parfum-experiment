FROM openjdk:8

RUN apt-get update \
        && apt-get install --no-install-recommends -y maven \
        && apt-get clean && rm -rf /var/lib/apt/lists/*;