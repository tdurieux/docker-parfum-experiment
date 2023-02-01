FROM python:3-alpine

WORKDIR /usr/src/app

RUN apk update && \
    apk add --no-cache python firefox-esr fontconfig ttf-freefont dbus-x11
RUN apk add --no-cache zlib-dev jpeg-dev gcc make libc-dev linux-headers

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN mkdir /download
