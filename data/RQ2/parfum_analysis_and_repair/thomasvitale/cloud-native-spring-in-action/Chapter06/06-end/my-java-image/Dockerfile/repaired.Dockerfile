FROM ubuntu:22.04

RUN apt-get update && apt-get install --no-install-recommends -y default-jre && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["java", "--version"]
