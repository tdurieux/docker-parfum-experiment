FROM nginx:1.17.0-alpine
## url setting
LABEL maintainer="yosong.heo@gmail.com"
ARG PAPER_VERSION=${PAPER_VERSION:-2.5.0}
RUN mkdir -p /var/www;
COPY default.conf /etc/nginx/conf.d/default.conf
WORKDIR /var/www
COPY ./scouter-paper.zip ./
## install
RUN apk add --no-cache -U tzdata wget unzip; cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime; wget ${INSTALL_URL}; unzip scouter-paper.zip; rm -f scouter-paper.zip
