FROM docker:latest

RUN apk add --no-cache curl rsync bash gnupg outils-signify
RUN mkdir -p /keys/
COPY docker-common.sh /keys/
WORKDIR /keys/
RUN chmod +x ./docker-common.sh
RUN ./docker-common.sh
