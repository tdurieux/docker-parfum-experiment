FROM alpine:latest

ENV TZ Asia/Shanghai
ENV PATH /usr/bin/v2ray:/usr/local/bin:$PATH
ENV IN_DOCKER true

RUN apk --no-cache add -f \
    ca-certificates \
    bash  \
    tzdata \
    curl \
    openssl \
    openssh-client \
    coreutils \
    bind-tools \
    socat \
    oath-toolkit-oathtool \
    tar \
    && rm -rf /var/cache/apk/*

EXPOSE 80 443

RUN mkdir /tmp/v2ray \
    && cd /tmp/v2ray \
    && curl -o go.sh -L -s https://raw.githubusercontent.com/ColetteContreras/v2ray-poseidon/master/install-release.sh \
    && bash go.sh --version VERSION \
    && rm -rf /tmp/v2ray /v2ray-linux-64.zip

CMD v2ray -config /etc/v2ray/config.json
