FROM python:3.8-alpine

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app
RUN apk add --no-cache --virtual .build-deps gcc libc-dev libxslt-dev linux-headers && \
    apk add --no-cache libxslt py3-lxml && \
    pip install --no-cache-dir -r requirements.txt && \
    apk del .build-deps

VOLUME ["/root/.config"]
EXPOSE 9999/tcp
ENTRYPOINT ["GMusicProxy"]
