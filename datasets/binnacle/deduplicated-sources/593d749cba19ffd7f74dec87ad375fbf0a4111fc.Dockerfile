# A one-shot container to issue/renew letsencrypt certificates with DNS challenge
# docker run -v /var/letsencrypt:/data --rm jokester/letsencrypt

FROM alpine:3.4
MAINTAINER Wang <momocraft@gmail.com>

ONBUILD ENV BUILD_DEP tar git
ONBUILD ENV RUN_DEP openssl py-pip bash curl
ENV LE_PATH /letsencrypt.sh-0.2.0

COPY data-seed /data-seed

RUN                                                                                                                               \
    apk add --update $BUILD_DEP $RUN_DEP                                                                                          \
    && curl -SsL https://github.com/lukas2511/letsencrypt.sh/archive/v0.2.0.tar.gz | tar xzv -C /                                 \
    && curl -SsL https://raw.githubusercontent.com/AnalogJ/lexicon/v1.1.6/examples/letsencrypt.default.sh -o /$LE_PATH/lexicon-hook.sh \
    && chmod +x $LE_PATH/lexicon-hook.sh                                                                                          \
    && pip install 'dns-lexicon'                                                                                                  \
    && ln -sv /data/config.sh $LE_PATH/                                                                                           \
    && apk del $BUILD_DEP && rm -rf /var/cache/apk/*

COPY run.sh /

VOLUME /data
WORKDIR /data

CMD bash /run.sh
