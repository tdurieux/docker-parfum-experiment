FROM golang:latest as builder
MAINTAINER Valentin Kuznetsov vkuznet@gmail.com

# update apt
RUN apt-get update && apt-get -y --no-install-recommends install unzip libaio1 wget && \
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - && \
    echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list && \
    apt-get install -y --no-install-recommends apt-transport-https && \
    apt update && \
    apt -y --no-install-recommends install filebeat && rm -rf /var/lib/apt/lists/*;

FROM debian:stable-slim
COPY --from=builder /usr/bin/filebeat /usr/bin/filebeat
COPY --from=builder /usr/share/filebeat /usr/share/filebeat
