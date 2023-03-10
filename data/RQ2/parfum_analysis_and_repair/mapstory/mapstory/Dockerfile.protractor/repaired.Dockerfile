FROM node:10.12
LABEL maintainer="Tyler Battle <tbattle@boundlessgeo.com>"

ENV DOCKER true
ENV SOURCE_HOME /opt

WORKDIR $SOURCE_HOME/mapstory
RUN set -ex \
    && npm install -g \
        codeceptjs-protractor \
        protractor \
    && npm link \
        protractor \
        selenium-webdriver \
    && npm install \
        pix-diff \
    && webdriver-manager update && npm cache clean --force;

WORKDIR $SOURCE_HOME/mapstory/tests
COPY scripts/accept.sh /usr/local/bin/accept
COPY mapstory/tests ./

CMD ["./runAllTests.sh"]
