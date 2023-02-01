FROM ca:latest

USER root

RUN apk add --no-cache python3 py3-pip gettext
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir flask

COPY --chown=keybase:keybase ./tests ./tests/
