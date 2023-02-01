FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y curl gnupg2 nodejs npm openjdk-11-jdk-headless python && rm -rf /var/lib/apt/lists/*;

RUN mkdir /src
WORKDIR /src

CMD ["bash", "-c", "npm i && npm run compile"]
