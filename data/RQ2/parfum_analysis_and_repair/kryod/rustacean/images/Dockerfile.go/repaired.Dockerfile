FROM ubuntu:latest

ENV DEBIAN_FRONTEND="noninteractive"

ENV TZ=Europe/Paris

RUN apt-get update -y && apt-get install --no-install-recommends -y golang-go && rm -rf /var/lib/apt/lists/*;