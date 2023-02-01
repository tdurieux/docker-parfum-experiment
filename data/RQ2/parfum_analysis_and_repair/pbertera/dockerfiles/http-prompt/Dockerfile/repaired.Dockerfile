FROM alpine:latest

RUN apk update && apk add --no-cache python bash py-pip

RUN pip install --no-cache-dir http-prompt

ENTRYPOINT ["http-prompt"]

