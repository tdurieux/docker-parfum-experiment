# NOTE : this file is not being used
FROM alpine:3.12

LABEL maintainer="shukri.adams@gmail.com" \
    src="https://github.com/shukriadams/arewedown"

RUN apk update \
    && apk upgrade \
    && apk add --no-cache bash \
    && apk add --no-cache sudo \
    && apk add --no-cache git \
    && apk add --no-cache curl \
    && apk add --no-cache nodejs=12.22.1-r0 \
    && apk add --no-cache npm=12.22.1-r0 \
    && mkdir -p /etc/arewedown \
    && adduser -D -u 1000 arewedown \
    && addgroup -S sudo \
    && adduser arewedown sudo \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && chmod 700 -R /etc/arewedown \
    && chown -R arewedown /etc/arewedown

COPY ./.stage/src/. /etc/arewedown

USER arewedown

CMD cd /etc/arewedown && npm start