FROM ubuntu:bionic
RUN apt-get update && apt-get install --no-install-recommends -y espeak mosquitto mosquitto-clients && rm -rf /var/lib/apt/lists/*;

WORKDIR /
COPY text2speech.sh /
CMD ./text2speech.sh
