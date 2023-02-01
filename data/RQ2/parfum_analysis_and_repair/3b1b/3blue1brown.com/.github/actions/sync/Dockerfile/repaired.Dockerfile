FROM python:3.8-alpine

# https://github.com/s3tools/s3cmd/blob/master/NEWS

RUN apk add --no-cache --update bash

RUN pip install --no-cache-dir s3cmd python-dateutil python-magic

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
