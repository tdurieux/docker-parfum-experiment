FROM alpine:latest
LABEL maintainer="philip.ackermann@cedalo.com"

RUN apk --no-cache add curl gnupg rsync unzip

# Copy the docker-compose files
COPY ./docker-compose /installer/docker-compose

# Copy the scripts
COPY ./start.sh /installer/start.sh
COPY ./stop.sh /installer/stop.sh
COPY ./update.sh /installer/update.sh

# Copy the script executed during the installation
COPY install.sh /install
RUN chmod +x /install

RUN mkdir -p /streamsheets

ENTRYPOINT ["/install"]