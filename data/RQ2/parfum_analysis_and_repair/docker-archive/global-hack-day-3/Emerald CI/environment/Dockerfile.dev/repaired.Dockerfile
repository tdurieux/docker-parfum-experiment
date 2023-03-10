FROM alpine
MAINTAINER Frederic Branczyk <fbranczyk@gmail.com>

RUN sed -i -e 's/v3\.2/edge/g' /etc/apk/repositories && \
    apk --update --no-cache add bash docker=1.8.2-r2 git && \
    rm -rf /var/cache/apk/*
COPY test-runner /bin/test-runner

RUN mkdir /project
WORKDIR /project

RUN mkdir /build
COPY script.sh /build/script.sh

ENTRYPOINT ["/build/script.sh"]

