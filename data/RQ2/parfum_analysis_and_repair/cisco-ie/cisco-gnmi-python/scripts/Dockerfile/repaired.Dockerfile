FROM python:3-alpine
RUN apk add --no-cache --virtual .build-deps gcc musl-dev libffi-dev openssl-dev g++
RUN pip install --no-cache-dir cisco-gnmi
ENTRYPOINT [ "cisco-gnmi" ]