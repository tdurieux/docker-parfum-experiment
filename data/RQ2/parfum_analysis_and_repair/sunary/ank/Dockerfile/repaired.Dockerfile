FROM sunary/python-2.7-alpine:0.1
MAINTAINER Nhat Vo Van "v2nhat@gmail.com"

#addition apk for image
RUN apk --update --no-cache add py-pip libffi-dev openssl-dev
RUN apk --update add gettext gcc libpq python-dev git && rm -rf /var/cache/apk/*

RUN pip install --no-cache-dir --upgrade pip

RUN mkdir -p /srv/logs
WORKDIR /srv/ank
RUN pip install --no-cache-dir -r requirements.txt

ADD . ./
ENTRYPOINT []
CMD []