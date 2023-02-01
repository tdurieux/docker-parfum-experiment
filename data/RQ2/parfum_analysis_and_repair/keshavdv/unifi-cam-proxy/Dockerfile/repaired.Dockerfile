FROM python:3.8-alpine3.10
WORKDIR /app

RUN apk add --no-cache --update gcc libc-dev linux-headers libusb-dev
RUN apk add --no-cache --update ffmpeg=4.1.6-r0 netcat-openbsd git

COPY . .
RUN pip install --no-cache-dir .

COPY ./docker/entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["unifi-cam-proxy"]
