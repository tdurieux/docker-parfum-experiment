FROM python:alpine
MAINTAINER Chad Rempp <crempp@gmail.com>
LABEL description="MDWeb production demo site"

COPY . /opt/mdweb

WORKDIR /opt/mdweb

RUN apk add --no-cache --update --virtual .build-deps \
        g++ \
        gcc \
    && pip install --no-cache-dir -r /opt/mdweb/requirements/test.txt \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*

RUN ["mkdir", "-p", "coverage"]

EXPOSE 5000

CMD ["nosetests", "--with-coverage", "--cover-erase", "--cover-html", "--cover-html-dir=coverage/html", "--with-xunit", "--xunit-file=coverage/nosetests.xml", "--cover-package=mdweb"]
