FROM alpine:3.5
MAINTAINER "Joan Ardiaca Jové"

# Base packages
RUN apk add --no-cache python3 python3-dev alpine-sdk apache2-dev
RUN pip3 install --no-cache-dir mod_wsgi

CMD tail -f /dev/null
