###############################################################################
#
#IMAGE:   tornado
#VERSION: 5.0.2
#
###############################################################################
FROM alpine:latest

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>

COPY daemon-greeting.py /usr/local/bin/daemon-greeting.py

###############################################################################
#install
###############################################################################
RUN apk upgrade --update-cache; \
    apk add py-pip; \
    pip install --no-cache-dir --upgrade pip; \
    pip install --no-cache-dir tornado; \
    rm -rf /tmp/* /var/cache/apk/*

CMD python /usr/local/bin/daemon-greeting.py "Default Service"
