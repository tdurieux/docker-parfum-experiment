FROM alpine

ENV AWS_DEFAULT_REGION us-east-1

RUN apk update && apk add --no-cache python3

RUN pip3 install --no-cache-dir awscli

ENTRYPOINT ["aws"]
