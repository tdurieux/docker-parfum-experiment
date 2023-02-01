# FROM ubuntu:16.04
# FROM debian:stable
FROM ubuntu:18.04

WORKDIR /app
RUN apt-get update && apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/gptune/GPTune.git
WORKDIR GPTune
RUN git fetch
RUN git pull https://github.com/gptune/GPTune master
RUN bash config_cleanlinux.sh
