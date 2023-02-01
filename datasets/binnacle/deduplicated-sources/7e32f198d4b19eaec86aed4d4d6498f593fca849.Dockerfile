FROM golang:1.10 as go-builder

ARG LEANOTE_VERSION=2.6.1
ARG LEANOTE_SOURCE=https://github.com/leanote/leanote.git

RUN echo build leanote ${LEANOTE_VERSION} from ${LEANOTE_SOURCE} \
    && mkdir -p /go/src/github.com/leanote/ \
    && cd /go/src/github.com/leanote \
    && git clone -b ${LEANOTE_VERSION} ${LEANOTE_SOURCE} \
    && cd leanote \
    && go run app/cmd/main.go \
    && go build -o bin/leanote-linux-amd64 github.com/leanote/leanote/app/tmp

FROM node:9-alpine as node-builder

COPY --from=go-builder /go/src/github.com/leanote/leanote /go/src/github.com/leanote/leanote

RUN cd /go/src/github.com/leanote/leanote \
    && npm install \
    && npm install -g gulp \
    && npm install gulp-minify-css \
    && gulp

FROM debian:jessie

COPY --from=go-builder /go/src/github.com/leanote/leanote/bin/leanote-linux-amd64 /leanote/bin/
COPY --from=go-builder /go/src/github.com/leanote/leanote/bin/run-linux-amd64.sh /leanote/bin/run.sh
COPY --from=go-builder /go/src/github.com/leanote/leanote/bin/src/ /leanote/bin/src/

COPY --from=node-builder /go/src/github.com/leanote/leanote/app/views /leanote/app/views
COPY --from=node-builder /go/src/github.com/leanote/leanote/conf /leanote/conf
COPY --from=node-builder /go/src/github.com/leanote/leanote/messages /leanote/messages
COPY --from=node-builder /go/src/github.com/leanote/leanote/mongodb_backup /leanote/mongodb_backup
COPY --from=node-builder /go/src/github.com/leanote/leanote/public /leanote/public

RUN apt-get update \
    && apt-get install -y wget ca-certificates \
    && mkdir -p /leanote/data/public/upload \
    && mkdir -p /leanote/data/files \
    && mkdir -p /leanote/data/mongodb_backup \
    # && rm -r /leanote/public/upload \
    # && rm -r /leanote/mongodb_backup \
    && ln -s /leanote/data/public/upload /leanote/public/upload \
    && ln -s /leanote/data/files /leanote/files \
    && ln -s /leanote/data/mongodb_backup /leanote/mongodb_backup \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 \
    && echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.4 main" \
    | tee /etc/apt/sources.list.d/mongodb-org-3.4.list \
    && apt update \
    && apt install -y \
        # Tools to export pdf
        wkhtmltopdf \
        # Tools to backup mongodb
        mongodb-org-tools \
        # wkhtmltopdf headless workaround
        xvfb \
        # Additionnal dependencies for better rendering
        ttf-freefont \
        fontconfig \
        dbus \
        psmisc \
    # Chinese fonts
    && apt-get install -y \
        fonts-arphic-bkai00mp \
        fonts-arphic-bsmi00lp \
        fonts-arphic-gbsn00lp \
        fonts-arphic-gkai00mp \
        fonts-arphic-ukai \
        fonts-arphic-uming \
        ttf-wqy-zenhei \
        ttf-wqy-microhei \
        xfonts-wqy \
    && fc-cache \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    # Wrapper for xvfb
    && mv /usr/bin/wkhtmltopdf /usr/bin/wkhtmltopdf-origin \
    && \
    echo '#!/usr/bin/env sh\n\
Xvfb :0 -screen 0 1024x768x24 -ac +extension GLX +render -noreset & \n\
DISPLAY=:0.0 wkhtmltopdf-origin $@ \n\
killall Xvfb\
' > /usr/bin/wkhtmltopdf && \
    chmod +x /usr/bin/wkhtmltopdf

VOLUME /leanote/data/

EXPOSE 9000

CMD ["sh", "/leanote/bin/run.sh"]
