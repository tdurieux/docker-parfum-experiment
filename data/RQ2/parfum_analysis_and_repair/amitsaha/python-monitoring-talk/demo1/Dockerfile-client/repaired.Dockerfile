FROM python:3.6.1-alpine
RUN apk add --no-cache --update curl apache2-utils && rm -rf /var/cache/apk/*
ADD ./make-requests.sh /make-requests.sh
VOLUME /data
CMD /make-requests.sh
